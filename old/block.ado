capture program drop block
program define block
	syntax, FILEname(string) [Verbose]

	tempname fh
	qui file open `fh' using `"`filename'"', write text replace
	local maxlines 1024

	forval i = 1/`maxlines' {
		qui disp _request2(_curline)
		local trimcurline `curline' // Remove trailing comments and surrounding spaces
		if strpos(`"`trimcurline'"', `"endblock"') == 1 {
			continue, break
		}
		file write `fh' `"`macval(curline)'"' _n
	}
	qui file close `fh'
	if ("`verbose'" != "") {
		di as text _n `"<<< Contents of "`filename'" <<<"'
		type "`filename'"
		di as text `">>> Contents of "`filename'" >>>" _n'
	}
end
