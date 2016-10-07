cap pr drop blockreplace
pr blockreplace
	syntax, INfile(string) OUTfile(string) Locals(string asis) [Verbose]

	loc i 0
	while (`"`locals'"'!="") {
		loc ++i
		gettoken key locals : locals, parse(" ")
		gettoken val locals : locals, parse(" ")
		loc key`i' `key'
		loc val`i' `"`val'"'
	}

	loc num_locals `i'
	tempfile tmp

	* RULE
	* i==1 : infile --> outfile
	* i is even : outfile --> tmp
	* i is odd : tmp --> outfile
	* AT THE END, do tmp --> outfile if num_locals was even
	
	forval i = 1/`num_locals' {

		loc odd = mod(`i', 2)
		if (`i' == 1) {
			loc left `"`infile'"'
			loc right `"`outfile'"'
		}
		else if (`odd') {
			loc left `"`tmp'"'
			loc right `"`outfile'"'
		}
		else {
			loc left `"`outfile'"'
			loc right `"`tmp'"'
		}		

		qui filefilter `"`left'"' `"`right'"', replace ///
			from("@`key`i''") ///
			to(`"`val`i''"')
	}

	if (!`odd') {
		copy `"`tmp'"' `"`outfile'"', replace
	}

	if ("`verbose'" != "") {
		di as text _n `"<<< Contents of "`outfile'" <<<"'
		type "`outfile'"
		di as text `">>> Contents of "`outfile'" >>>" _n'
	}
end
