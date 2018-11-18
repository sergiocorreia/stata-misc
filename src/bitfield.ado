*! version 1.0.0 18nov2018

// -------------------------------------------------------------
// Create and use bitfields, so I can e.g. collapse -long- data
// -------------------------------------------------------------

cap pr drop bitfield
pr bitfield
	gettoken subcommand 0 : 0
	_assert inlist("`subcommand'", "pack", "unpack", "describe"), rc(197) ///
		msg("invalid subcommand (valid subcommands: pack, unpack, describe)")
	`=strtitle("`subcommand'")' `0'
end


cap pr drop Describe
pr Describe
	syntax varname(numeric)
	loc chars num_parts num_levels levels input by
	foreach char of local chars {
		loc `char' : char `varlist'[`char']
	}
	di
	loc vars = plural(`num_parts', "variable")
	di as text "Bitfield {res}`varlist'{txt} (uses `num_parts' `vars')"
	di as text " - Input variable: {res}{col 22}`input'"
	di as text " - Number of levels: {res}{col 22}`num_levels'"
	di as text " - Levels: {res}{col 22}`levels'"
	di as text " - Collapsed by: {res}{col 22}`by'"
	di
end


cap pr drop Pack
pr Pack
syntax newvarlist(max=1) [if], INPUTvar(name) [BY(varlist numeric)] [Verbose]

	loc verbose = "`verbose'" != ""

	if (`"`if'"' != "") qui keep `if'
	
	* On paper, we could use up to -double-
	* However we can't use 62 (8*8-2) bits with -double- because we lose 11 due to the exponent
	* https://www.doc.ic.ac.uk/~eedwards/compsys/float/
	* Thus, we only have 53 (52?) bits available, so we have fewer bits-per-byte than with -long-

	if (`verbose') di as text "bitfield: processing input variable {res}`inputvar'{txt}"
	loc type : type `inputvar'
	_assert inlist("`type'", "int", "long", "float", "double"), msg("Input variable `inputvar' must be numerical")
	_assert (`inputvar' == int(`inputvar')) & (`inputvar' >= 0) & !mi(`inputvar')
	
	* Available bits: # of bytes minus one for MVs and one for negatives
	* Bytes per type: byte=1 int=2 long=4 (excluded float and double which are inefficient)
	loc sizeof = 8 * 4 - 2

	* Compute list of possible levels
	qui glevelsof `inputvar', loc(levels)
	loc num_levels = r(J)

	* We must use multiple variables ("parts") if there are more levels than what -double- allows
	loc num_parts = ceil(`num_levels' / `sizeof')
	loc last_size = mod(`num_levels', `sizeof') // size of last part

	* Pick smallest possible size for the last part
	loc last_i = ceil((`last_size' + 2) / 8)
	loc last_type : word `last_i' of byte int long long error

	loc part 0
	forval i = 1/`num_levels' {
		if (mod(`i', `sizeof') == 1) {
			loc ++part
			loc check 0
			loc type = cond(`part' == `num_parts', "`last_type'", "long")
			loc cmd`part' "gen `type' `varlist'__`part' = "
		}

		loc level : word `i' of `levels'
		loc value = 2 ^ mod(`i' - 1, `sizeof')
		loc check = `check' + `value'
		assert `check' < c(max`type')
		loc cmd`part' `cmd`part'' + `value'*(`inputvar'==`level')
		assert !strpos("`cmd`part''", ".")
		loc levels`part' `levels`part'' `level'
	}

	* Need to be careful to not count repeated instances
	keep `by' `inputvar'
	cap gisid `by' `inputvar'
	if (c(rc)) {
		qui bys `by' `inputvar': keep if _n == 1
	}

	* Create bitfield variables
	if (`verbose') di as text "bitfield: creating variables"
	forval i = 1/`num_parts' {
		if (`verbose') di as text"CMD: {res}`cmd`i''"
		`cmd`i''
		***qui bys `by': replace `varlist'__`i' = sum(`varlist'__`i')
	}

	* Collapse dataset
	gcollapse (sum) `varlist'__*, by(`by') fast
	***qui by `by': keep if _n == _N
	***keep `by' `varlist'__*

	format %12.0f `varlist'__*
	* compress `varlist'__*

	* Save information about the bitfield as chars
	rename `varlist'__1 `varlist'
	char `varlist'[num_parts] `num_parts'
	char `varlist'[levels] `levels'
	char `varlist'[num_levels] `num_levels'
	char `varlist'[input] `inputvar'
	char `varlist'[by] `by'
	la data "Bitfield of `inputvar' by `by' (`num_levels' possible values)"

end

// -------------------------------------------------------------

cap pr drop Unpack
pr Unpack
	syntax varname(numeric), GENerate(name) VALue(integer) [REPLACE] [Verbose]

	_assert (`value' == int(`value')) & (`value' >= 0) & !mi(`value')

	if ("`replace'" == "") {
		qui gen byte `generate' = .
	}
	else {
		cap gen byte `generate' = .
		if (c(rc)) replace `generate' = .
	}

	loc levels : char `varlist'[levels]
	loc input : char `varlist'[input]
	loc by : char `varlist'[by]

	la var `generate' "Indicator: `value' in `input' by `by'?"
	format %2.0f `generate'

	* Find out overall location of value
	loc sizeof = 8 * 4 - 2
	loc overall_pos : list posof "`value'" in levels // Could have also used "word # of"
	if (`overall_pos' == 0) {
		di in red "(warning: value `value' was never in `input')"
		qui replace `generate' = 0 if !missing(`varlist')
		exit
	}
	
	* Find out in which variable is -value-, and in which bit of the variable
	loc part = ceil((`overall_pos') / `sizeof') // BUGBUG!??!
	loc pos = 1 + mod(`overall_pos' - 1, `sizeof')
	if ("`verbose'" != "") di as text "bitfield unpack: level `value' located in variable `part' slot `pos' (pos. `overall_pos' overall)"
	_assert `overall_pos' == `sizeof' * (`part' - 1) + `pos'

	* Compute answer
	if (`part' > 1) loc varlist `varlist'__`part'
	qui replace `generate' = int( mod(`varlist', 2 ^ `pos') / 2 ^ (`pos'-1) ) if !mi(`varlist')

end
