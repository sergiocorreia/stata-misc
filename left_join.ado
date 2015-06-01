capture program drop left_join
program define left_join
	gettoken subcmd 0 : 0
	assert inlist("`subcmd'", "prepare", "join")
	local subcmd = proper("`subcmd'")
	`subcmd' `0'
end

capture program drop Join
program define Join
	di as text "(merging using dataset)"
	syntax anything(name=pattern), panelvar(name) timevar(name) [bw_left(integer 0) bw_right(integer 0)]
	
	mata: st_local("varlist", pattern_match("`pattern'", usingvarlist))

	assert_msg "`varlist'"!="", msg("empty varlist after matching patterns (`pattern')")
	di "{txt}(patterns matched: {res}`varlist'{txt})"

	local sortedby : sortedby
	assert_msg "`sortedby'"!="", msg("dataset not sorted")
	local first : word 1 of `sortedby'
	assert_msg "`first'"=="`panelvar'", msg("dataset not sorted first by `panelvar' (`sortedby')")

	tempvar bylength
	by `panelvar': gen long `bylength' = _N

	foreach var of local varlist {
		mata: st_local("type", asarray(vartypes, "`var'"))
		gen `type' `var' = 0
	}

	local N = c(N)
	local start 1
	while (`start'<=`N') {
		local end = `start' + `bylength'[`start'] - 1
		local panelvalue = `panelvar'[`start']
		// di "{txt}`panelvar'=`panelvalue'"
		assert `panelvalue'==`panelvar'[`end']

		foreach var of local varlist {
			mata: rules = asarray(asarray(varvalues, "`var'"), `panelvalue')
			mata: st_local("num_rules", strofreal(rows(rules)))
			// di as text " - `var' has `num_rules' rules"
			forval i = 1/`num_rules' {
				mata: st_local("value", rules[`i',1])
				mata: st_local("t", rules[`i',2])

				local bw0 = `t' - `bw_left'
				local bw1 = `t' + `bw_right'
				local cond "`bw0'<=t & t<=`bw1'"
				local delta = `bw1' - `bw0'
				if (`delta'<=7) {
					local cond "inlist(t"
					forval s = `bw0'/`bw1' {
						local cond "`cond', `s'"
					}
					local cond "`cond')"
				}

				di `"{txt}cmd=[{res}replace `var' = `value' in `start'/`end' if `cond'{txt}]"'
				qui replace `var' = `var' + `value' in `start'/`end' if `cond'
			}
		}

		local start = `end' + 1
	}

end

capture program drop Prepare
program define Prepare
	di as text "(indexing using dataset)"
	syntax using/ , panelvar(name) timevar(name)
 	use "`using'", clear
 	conf var `panelvar'
 	conf var `timevar'

 	* Store types
 	mata: vartypes =  asarray_create()
 	qui ds `panelvar' `timevar', not
 	mata: usingvarlist = tokens("`r(varlist)'")
 	mata: usingvarlist'
 	foreach var of varlist `r(varlist)' {
 		local type : type `var'
 		mata: asarray(vartypes, "`var'", "`type'")
 	}

	rename _all __=
	rename __`panelvar' `panelvar'
	rename __`timevar' `timevar'
	qui reshape long __, i(`panelvar' `timevar') j(var) string
	rename __ value
	qui drop if value==0
	order var
	sort var `panelvar' `timevar'
	// tab1 var // So you can see what values are there

	* Store values
	mata: varvalues = asarray_create()
	local N = c(N)
	forval i = 1/`N' {
		local var = var[`i']
		local value = value[`i']
		local panelvalue = `panelvar'[`i']
		local timevalue = `timevar'[`i']

		mata: attach(varvalues, "`var'", `panelvalue', "`value'", "`timevalue'")
	}
end

mata:
void function attach(transmorphic dict, string scalar varname, real scalar panelvar, string scalar value, string scalar cond) {
	if (!asarray_contains(dict, varname)) {
		asarray(dict, varname, asarray_create("real"))
		asarray_notfound( asarray(dict, varname) , J(0,2,"") )
	}
	// dict[varname][panelvar].append([value, cond])
	asarray(asarray(dict, varname), panelvar, asarray(asarray(dict, varname), panelvar) \ (value, cond))
}

string scalar pattern_match(string scalar patterns, rowvector usingvarlist) {
	ans = J(1,0,"")
	patterns = tokens(patterns)
	assert(length(usingvarlist)>0)
	for (i=1; i<=length(usingvarlist); i++) {
		for (j=1; j<=length(patterns); j++) {
			if (strmatch(usingvarlist[i], patterns[j])) {
				ans = ans, usingvarlist[i]
				break
			}
		}
	}
	return(invtokens(ans))
}
end

