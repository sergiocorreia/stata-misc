* Minor modification of -dirlist-, where we replace shell with hshell
* See: http://fmwww.bc.edu/RePEc/bocode/d/dirlist.html

*! 1.3.1 MA 2005-04-04 12:54:30
* saves directory data in r() macros fnames, fdates, ftimes, fsizes, nfiles
*--------+---------+---------+---------+---------+---------+---------+---------

program define hdirlist, rclass
	syntax anything , [Verbose]
	tempfile dirlist
	loc verbose = ("`verbose'" != "")

	if "`c(os)'" == "Windows" {
		local shellcmd `"dir `anything' > `dirlist'"'
	}
	else if "`c(os)'" == "MacOSX" {
		local anything = subinstr(`"`anything'"', `"""', "", .)
		local shellcmd `"ls -lT `anything' > `dirlist'"'
	}
	else if "`c(os)'" == "Unix" {
		local anything = subinstr(`"`anything'"', `"""', "", .)
		local shellcmd `"ls -l --time-style='+%Y-%m-%d %H:%M:%S'"'
		local shellcmd `"`shellcmd' `anything' > `dirlist'"'
	}

	hshell, cmd(`shellcmd') shell(hidden) // verbose(`verbose')

	* read directory data from temporary file
	
	tempname fh
	
	file open `fh' using "`dirlist'", text read
	file read `fh' line
	
	local nfiles = 0
	local curdate = date("`c(current_date)'","dmy")
	local curyear = substr("`c(current_date)'",-4,4)

	if (`verbose') di "{txt}Name{col 10}Date{col 20}Time{col 30}Size"

	while r(eof)==0  {
	
		if `"`line'"' != "" & substr(`"`line'"',1,1) != " " {

			* read name and data for each file

			if "`c(os)'" == "MacOSX" {
				local fsize : word 5 of `line'
				local fda   : word 6 of `line'
				local fmo   : word 7 of `line'
				local ftime : word 8 of `line'
				local fyr   : word 9 of `line'
				local fname : word 10 of `line'
				local fdate = string(date("`fmo' `fda' `fyr'","mdy"),"%dCY-N-D")
			}
			else if "`c(os)'" == "Unix" {
				local fsize : word 5 of `line'
				local fdate : word 6 of `line'
				local ftime : word 7 of `line'
				local fname : word 8 of `line'
			}
			else if "`c(os)'" == "Windows" {
				local fdate : word 1 of `line'
				local ftime : word 2 of `line'
				local word3 : word 3 of `line'
				
				if upper("`word3'")=="AM" | upper("`word3'")=="PM" {
					local ftime "`ftime'-`word3'"
					local fsize : word 4 of `line'
					local fname : word 5 of `line'
				}
				else {
					local fsize : word 3 of `line'
					local fname : word 4 of `line'
				}							
			}

			if (`verbose') di "{txt}`fname'{col 10}`fdate'{col 20}`ftime'{col 30}`fsize'"

			local fnames "`fnames' `fname'"
			local fdates "`fdates' `fdate'"
			local ftimes "`ftimes' `ftime'"
			local fsizes "`fsizes' `fsize'"
			local nfiles = `nfiles' + 1

		}

		file read `fh' line
	}
	
	file close `fh'
	return local fnames `fnames'
	return local fdates `fdates'
	return local ftimes `ftimes'
	return local fsizes `fsizes'
	return local nfiles `nfiles'
end
