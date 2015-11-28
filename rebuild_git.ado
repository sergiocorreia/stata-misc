program define rebuild_git
	syntax anything(name=project), [GITpath(string)]

	* Try to detect git path if not set; there is no "conf folder" so we will use a trick with "conf new file"
	if ("`gitpath'"=="") {
		local rand = int(runiform()*1e12)
		local paths `" "D:/Github" "D:/Git" "C:/Github" "C:/Git" "'
		foreach path of local paths {
			cap confirm new file "`path'/`rand'"
			assert inlist(c(rc), 0, 603) // 603=could not be opened
			if (c(rc)==0) {
				local gitpath "`path'"
				continue, break
			}
		}
		assert_msg "`gitpath'"!="" , msg("Could not detect Github folder, use gitpath() option")
	}

	* assert_msg inlist("`project'", "quipu", "reghdfe"), msg("project does not exist: `project'")

	cap cls
	di as text "(note: rebuilding will silently fail if we cannot run .py files directly from the command line)"
	local projectpath "`gitpath'/`project'"
	local makefile "`projectpath'/build/build.py"
	
	di as text _n "{title:Running build.py}"
	di as text `"[cmd] shell `makefile"'
	shell "`makefile'"

	di as text _n "{title:Old version if already installed:}"
	cap noi which `project'

	di as text _n "{title:Uninstalling if already installed}"
	cap ado uninstall `project'
	if ("`project'"=="reghdfe") cap ado uninstall hdfe

	di as text _n "{title:Installing from local git repo}"
	qui net from "`projectpath'/package/"
	net install `project'
	if ("`project'"=="reghdfe") net install hdfe

	di as text _n "{title:New version:}"
	cap noi which `project'
end
