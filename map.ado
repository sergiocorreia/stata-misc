* MAP.ADO - Loop a command

* EG: map (lhs=a b c) (rhs=x y z), verbose: reg @lhs @{rhs}
* EG: map (lhs=a b c) (rhs=x y z), v bracket: reg @lhs @{rhs}
* EG: map (w=FOO BAR) (x = a b c) (y = 1 2 3 4): di as text "w=@{w} x=@x ... y=@y"

* -bracketonly- is a workaround in case you have e.g. @y and @yes or something like that
* NOTE: Outer loops are to the left, inner loops are to the right

cap pr drop map
program define map
	version 12

	* Parse colon
	_on_colon_parse `0'
	local cmd `s(after)'
	local 0 `s(before)'


	* Parse templates, each within parenthesis
	local num_total 1
	_parse expand keyval rest : 0
	forval i = 1/`keyval_n' {
		Assert `"`keyval_`i''"'!="", msg("nothing inside parenthesis")
		gettoken key_`i' keyval_`i' : keyval_`i', parse(" =")
		gettoken eqsign values_`i' : keyval_`i', parse("=")
		local num_`i' : word count `values_`i''
		Assert `num_`i'' > 0, msg("rhs of `key_`i'' is empty")
		local num_total = `num_total' * `num_`i''
		local cursor_`i' 1
		local value_`i' : word 1 of `values_`i''
	}
	Assert `keyval_n'>0, msg("nothing to iterate")

	* Parse options
	local 0
	if (`"`rest_op'"'!="") local 0 , `rest_op'
	local do do // Multiline-related

	if (`"`0'"'!="") {
		Assert strpos(ltrim(`"`0'"'), ",")==1, msg("parsing error, no comma in -map- options")
		syntax, [Verbose] [BRACKETonly] [DRYrun] /// Dryrun is inspired on the -rename- option
			[RUN] [locals(string asis)] // Multiline options
		if ("`run'"!="") local do run // Multiline-related
	}
	local verbose = ("`verbose'"!="") // Convert to 0/1
	local multiline = strpos(trim(`"`cmd'"'), "{{")==1
	if (`verbose') {
		local iterations = plural(`num_total', "iteration")
		di as text "(map: performing `num_total' `iterations' with multiline=`multiline')" _n
	}
	

	if (`multiline') {
		while (`"`locals'"'!="") {
			gettoken key locals : locals, parse(" ")
			gettoken value locals : locals, parse(" ")
			local arg_keys `arg_keys' `key'
			local arg_values `"`arg_values' "`value'""'
		}
		tempfile source tmpsource replacedsource
		tempname fh
		qui file open `fh' using `"`source'"', write text replace
		if ("`arg_keys'"!="") file write `fh' `"args `arg_keys'"' _n
		local maxlines 1024
		forval i = 1/`maxlines' {
			assert_msg (`i'<`maxlines'), msg("map error: maxlines (`maxlines') reached in inline block!" _n "(did you forget to close the block?)")
			qui disp _request2(_curline)
			local trimcurline `curline' // Remove trailing comments and surrounding spaces
			if strpos(`"`trimcurline'"', "}}")==1 {
				continue, break
			}
			*di as error `"[`i'] <`curline'>"'
			file write `fh' `"`macval(curline)'"' _n
		}
		qui file close `fh'
		if (`verbose') {
			di as text "<<< Contents of inline block <<<"
			type "`source'", asis
			di as text ">>> Contents of inline block >>>"
		}
	}

	* Run the nested foreachs
	* (tricky loop, iterators are -i- (left-to-right) and -cursor_#- (up and down))
	
	forv iter=1/`num_total' {
		if (`multiline') qui copy `"`source'"' `"`replacedsource'"', replace

		local replaced_cmd `cmd'
		forv i=`keyval_n'(-1)1 {
			if (`multiline') {
				if ("`bracketonly'"=="") {
					qui filefilter `"`replacedsource'"' `"`tmpsource'"' , from("@`key_`i''") to("`value_`i''") replace
					qui filefilter `"`tmpsource'"' `"`replacedsource'"' , from("@{`key_`i''}") to("`value_`i''") replace
				}
				else {
					qui filefilter `"`replacedsource'"' `"`tmpsource'"' , from("@{`key_`i''}") to("`value_`i''") replace
					qui filefilter `"`tmpsource'"' `"`replacedsource'"' , from("@{`key_`i''}") to("`value_`i''") replace // Useless second line, but just to be sure replacedsource has the final version
				}
			}
			else {
				if ("`bracketonly'"=="") local replaced_cmd : subinstr local replaced_cmd "@`key_`i''" "`value_`i''", all
				local replaced_cmd : subinstr local replaced_cmd "@{`key_`i''}" "`value_`i''", all
			}
		}

		if strpos(`"`replaced_cmd'"', "@") {
			di as error "Warning: @ found in command, did you replace all placeholders?"
			* TODO: Allow the same for multiline, using hexdump FN analyze results
		}

		if (`verbose') {
			local msg `""{bf:iteration #`iter': }""'
			forv j=1/`keyval_n' {
				local msg `"`msg' "(`key_`j'' = " as text "`value_`j''" as input ") ""'
			}
			di _n as input "{hline}" _n `msg' _n as input "{hline}"
			if (!`multiline') di as input "{bf:>>>} " as input `"`replaced_cmd'"'
		}
		
		if ("`dryrun'"=="") {
			if (`multiline') {
				**type `"`replacedsource'"', asis
				`do' `"`replacedsource'"' `arg_values'
			}
			else {
				`replaced_cmd'
			}
		}
		
		* Update cursors
		forv i=`keyval_n'(-1)1 {
			if (`cursor_`i''<`num_`i'') {
				local ++cursor_`i'
				local value_`i' : word `cursor_`i'' of `values_`i''
				continue, break
			}
			else {
				local cursor_`i' 1
				local value_`i' : word 1 of `values_`i''
			}
		}
	}
end

* -Assert- copied from -reghdfe- (or just use assert_msg)
cap pr drop Assert
program define Assert
    syntax anything(everything equalok) [, MSG(string asis) RC(integer 198)]
    if !(`anything') {
        di as error `msg'
        exit `rc'
    }
end

exit
