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

	**local i 0
	**local num_total 1
	**while (`"`0'"'!="" & strpos(ltrim(`"`0'"'), ",")!=1 ) {
	**	gettoken template 0 : 0, parse(" ") match(parens)
	**	Assert "`parens'"!="", msg("parenthesis not found")
	**	Assert `"`template'"'!="", msg("nothing inside parenthesis")
	**	local ++i
	**	gettoken key_`i' template : template, parse(" =")
	**	gettoken eqsign values_`i' : template, parse("=")
	**	local num_`i' : word count `values_`i''
	**	Assert `num_`i'' > 0, msg("rhs of `key_`i'' is empty")
	**	local num_total = `num_total' * `num_`i''
	**	*di as result"[`key_`i''] = [`values_`i'']"'
	**	local cursor_`i' 1
	**	local value_`i' : word 1 of `values_`i''
	**}
	**local keyval_n `i'
	**Assert `keyval_n'>0, msg("nothing to iterate")

	* Parse options
	local 0
	if (`"`rest_op'"'!="") local 0 , `rest_op'

	if (`"`0'"'!="") {
		Assert strpos(ltrim("`0'"), ",")==1, msg("parsing error, no comma in -map- options")
		syntax, [Verbose] [BRACKETonly] [DRYrun] // Dryrun is inspired on the -rename- option
	}
	local verbose = ("`verbose'"!="") // Convert to 0/1
	
	if (`verbose') {
		local iterations = plural(`num_total', "iteration")
		di as text "(map: performing `num_total' `iterations')" _n
	}

	* Run the nested foreachs
	* (tricky loop, iterators are -i- (left-to-right) and -cursor_#- (up and down))
	
	forv iter=1/`num_total' {
		* Run command
		local replaced_cmd `cmd'
		forv i=`keyval_n'(-1)1 {
			if ("`bracketonly'"=="") local replaced_cmd : subinstr local replaced_cmd "@`key_`i''" "`value_`i''", all
			local replaced_cmd : subinstr local replaced_cmd "@{`key_`i''}" "`value_`i''", all
		}
		if strpos(`"`replaced_cmd'"', "@") {
			di as error "Warning: @ found in command, did you replace all placeholders?"
		}

		if (`verbose') {
			local msg `""{bf:iteration #`iter': }""'
			forv j=1/`keyval_n' {
				local msg `"`msg' "(`key_`j'' = " as text "`value_`j''" as input ") ""'
			}
			di _n as input "{hline}" _n `msg' _n as input "{hline}"
			di as input "{bf:>>>} " as input `"`replaced_cmd'"'
		}
		
		if ("`dryrun'"=="") {
			`replaced_cmd'
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




set more off
clear all
cls

local 0 `"(lhs=a b c) (rhs=spam eggs) (iv=x yy) (tag=7 "Some Spam" sp): reg @lhs @{rhs}"'

local i 4
di `"`: word 2 of `values`i''"'

exit
parse()
match(par) | bind

