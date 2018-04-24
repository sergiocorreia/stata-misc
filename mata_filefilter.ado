* DESIGN DECISIONS:
* 1) input and output files are the same
* 2) Missing FROM means we'll only attach EOLs

capture program drop mata_filefilter
program define mata_filefilter
	syntax using/ , [FROM(string) TO(string) EOL(string)] // replace is always true...
	tempfile destination
	mata: filefilter("`using'", "`destination'", "`from'", "`to'", "`eol'")
	*erase "`using'"
	copy "`destination'" "`using'", replace
end



mata:
void filefilter(string scalar source, string scalar dest, string scalar from, string scalar to, string scalar eol)
{
	//"~~~~~", source
	fh_in  = fopen(source, "r")
	fh_out = fopen(dest, "w")
	while ((line=fget(fh_in))!=J(0,0,"")) {
		if (from != "") line = subinstr(line, from, to)
	    fput(fh_out, line + eol)
	}
	fclose(fh_out)
	fclose(fh_in)
}
end
