*! version 0.2.0 16jul2019
program define fast_destring
	syntax [varlist(string default=none)], ///
		[FLAGVARS(varlist)] ///
		[DATEVARS(varlist) DATEFMT(string)] ///
		REPLACE /// Mandatory; alternative is Generate(newvarlist)
		/// IGNORE(chars); forget about unicode
		/// FLOAT
		/// PERCENT
		// DPCOMMA

	unab allvars : *
	tempvar new
	
	foreach var of local varlist {
		di as text "- `var'"
		qui gen double `new' = real(`var')
		qui cou if mi(`new') & !mi(`var')
		_assert !r(N), msg("`var': contains non-numeric characters")
		drop `var'
		rename `new' `var'
	}

	foreach var of local flagvars {
		di as text "- `var'"
		qui replace `var' = "" if `var'=="U" // U=Unknown
		_assert inlist(`var', "Y", "N", ""), msg(`"`var': contains other characters besides "Y", "N", "U", and """')
		qui gen byte `new' = (`var' == "Y") if inlist(`var', "Y", "N")
		drop `var'
		rename `new' `var'
	}

	foreach var of local datevars {
		di as text "- `var'"
		qui gen long `new' = date(`var', "`datefmt'")
		qui cou if mi(`new') & !mi(`var')
		_assert !r(N), msg("`var': contains invalid dates")
		drop `var'
		rename `new' `var'
	}
	if ("`datevars'" != "") format %td `datevars'

	if ("`flagvars'" != "") {
		la def yesno 0 "No" 1 "Yes", modify
		la val `flagvars' yesno
	}

	qui compress `varlist' `datevars'
	order `allvars'
end
