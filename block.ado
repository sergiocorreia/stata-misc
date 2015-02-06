* Proof of concept..
* Reason for some design decisions:
* - maxlines are a last-resort when the do-file doesn't end
* - to allow for conditional expressions, we can use double brackets {{ and save the file to disk
* - to allow locals to be evaluated, we have the locals() option
* Locals are as in KEY1 VALUE1 KEY2 VALUE2 ..
* Draws inspiration from Roger Newson's -rsource-

* Missing features:
* - Fails when combined with e.g. -map-, -by-, etc., which work on the code on the same line
* - Doesn't allow additional options in [*]

* Bug in handling the locals.. see quipu index and map.ado for soln

capture program drop block
program define block
	version 12

	local do do
	if trim(`"`0'"')=="" {
		local terminator "endblock"
	}
	else if strpos(trim(`"`0'"'), "{")==1 {
		local terminator = cond(strpos(trim(`"`0'"'), "{{")==1, "}}", "}")
	}
	else {
		syntax , [Verbose] [RUN] [locals(string asis)] [*]
		if ("`options'"=="") {
			local terminator "endblock"
		}
		else {
			assert strpos(trim(`"`options'"'), "{")==1
			local terminator = cond(strpos(trim(`"`options'"'), "{ {")==1, "}}", "}") // Syntax issue/bug: it replaces "{{" with "{ {"
		}
		if ("`run'"!="") local do run
		// MAYBE FORGET ABOUT {{ local options.. remove {
	}

	while ("`locals'"!="") {
		gettoken key locals : locals, parse(" ")
		gettoken value locals : locals, parse(" ")
		local `key' `value'
	}

	tempfile source
	tempname fh
	qui file open `fh' using `"`source'"', write text replace

	local maxlines 1024
	forval i = 1/`maxlines' {
		qui disp _request2(_curline)
		local trimcurline `curline' // Remove trailing comments and surrounding spaces
		if strpos(`"`trimcurline'"', "`terminator'")==1 {
			continue, break
		}
		*di as error `"[`i'] <`curline'>"'
		file write `fh' `"`macval(curline)'"' _n
	}
	qui file close `fh'
	if ("`verbose'"!="") di as text _n "<<< Contents of inline block <<<"
	if ("`verbose'"!="") type "`source'"
	if ("`verbose'"!="") di as text ">>> Contents of inline block >>>" _n
	if ("`verbose'"!="") di as text "(executing inline block)"
	`do' `"`source'"'
end
