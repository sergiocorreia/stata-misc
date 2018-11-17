* SAKE - Stata's make

capture program drop sake
program define sake
	mata: st_local("inputhash", strofreal(hash1(`"`0'"'), "%20.0f"))

	cap  _on_colon_parse `0'
	if (!c(rc)) {
		loc 0 `s(before)'
		loc cmd `s(after)'
	}

	syntax, [Date(string asis) Hash(string asis) LOCal(name local) Verbose]
	loc verbose = ("`verbose'" != "")
	_assert `"$sakepath"' != "", msg("global -sakepath- missing")
	_assert (`"`date'"' != "") + (`"`hash'"' != "") > 0, msg("must specify at least one date() or hash()")
	_assert (`"`cmd'"' != "") + (`"`local'"' != "") == 1, msg("must either use colon syntax or specify local()")

	loc fn "$sakepath/`inputhash'.txt"
	cap confirm file "`fn'"
	if (c(rc)) {
		di as error `"sake date: run=1 because file "`fn'" was not found"'
		loc run 1
	}
	else {
		* Read cache file
		* TODO!!!

		* Delete cache file and create a new handle
		* TODO!!!

		loc run 0 // 1 if we need to run the code again

		* Validate files by date		
		while (`"`date'"' != "") {
			gettoken fn date : date
			di as error `"<`fn'>"'
			CheckDate using "`fn'", cachefh(`fh')
		}
		
	}

	if ("`local'" != "") {
		c_local `local' `run'
	}
	else if (`run' == 1) {
		di as error `"[CMD] `cmd'"'
		`cmd'
		di as error "     RESULT: `run'"
	}


end


capture program drop CheckDate
program define CheckDate
	syntax using/

	cap confirm file "`using'"
	if (c(rc)) {
		di as error `"sake date: run=1 because file "`using'" was not found"'
		c_local run 1
		exit
	}

	hdirlist "`using'", v
	return list
end
