*! version 1.1.0 24nov2018

* USAGE: hshell, cmd(xelatex ...) v(1)
* TODO: find out how to copy quietly without "1 file(s) copied."
* TODO: it seems we can kill the process we launch (CMD) but not the children one (e.g. notepad)

cap pr drop hshell
program hshell
	syntax, cmd(string) [Verbose(integer 0) SHell(string asis) Timeout(real 10)]
	if ("`shell'"=="") loc shell "hidden"

	* Validate syntax
	_assert inlist("`shell'", "standard", "hidden", "noisy"), ///
		msg("shell() option invalid; allowed values are {it:standard}, {it:hidden}, and {it:noisy}")
	_assert inlist(`verbose', 0, 1), ///
		msg("verbose() option invalid; allowed values are {it:0} and {it:1}")
	_assert (`timeout' > 0), msg("timeout() must be positive")
	
	* Disable hidden shell on Linux/OS-X (not required)
	if (c(os) != "Windows" & "`shell'" == "hidden") loc shell standard

	* Disable hidden shell if -parallel- is not installed (and warn about it)
	if ("`shell'" == "hidden") {
		cap which procexec
		if (_rc) {
			di as error "(the -hidden- option requires the parallel package from Github)"
			di as error "net install parallel, from(https://raw.github.com/gvegayon/parallel/master/) replace"
			loc hidden
		}
	}

	* Run command...
	tempfile stdout touchfile
	
	if ("`shell'" == "hidden") {
		* Hidden shell explanation:
		* We will -touch- a new file, and then wait until the file is created
		if (`verbose' > 0) di as text "(running hidden shell; waiting up to `timeout's)"
		loc sleeptime 100 // ms
		loc maxiter = int(`timeout' * (1000 / `sleeptime'))
		scalar PROCEXEC_HIDDEN = 1
		scalar PROCEXEC_ABOVE_NORMAL_PRIORITY = 1
		// To create chain commands, we could just do: (`cmd' && `cmd')
		procexec cmd.exe /c ((`cmd') & copy NUL "`touchfile'") > "`stdout'" 2>&1
		loc pid = r(pid)

		* Cleanup
		scalar drop PROCEXEC_HIDDEN
		scalar drop PROCEXEC_ABOVE_NORMAL_PRIORITY

		if (`verbose') di as text "(PID is `pid')"

		loc i 0
		while (1) {
			loc ++i
			cap conf file "`touchfile'"
			if (!_rc) continue, break
			if (`i' > `maxiter') {

				* Try to kill runaway process
				cap prockill `pid'
				if (_rc) {
					di as error _n "command failed; output:"	
				}
				else {
					di as error _n "command timed out; output:"
				}

				di as error "{hline}"
				noi type "`stdout'"
				di as error "{hline}"
				di as error "Exceeded timeout of `sleeptime's; you can set a higher timeout, including timeout(.)"
				error 691
			}
			di "." _c
			sleep `sleeptime'
		}
		di
		conf file "`touchfile'" // sanity check
	}
	else if ("`shell'" == "noisy") {
		if (`verbose' > 0) di as text "(running standard shell w/out redirection, and pausing)"
		di as error `"[CMD] `cmd'"'
		shell (`cmd') & pause
	}
	else {
		if (`verbose' > 0) di as text "(running standard shell)"
		shell (`cmd') > "`stdout'" 2>&1
		cap noi conf file "`stdout'"
	}

	* Print output
	if (`verbose' & "`shell'" != "noisy") {
		di as text "{bf:[STDOUT/STDERR]}"
		di as text "{hline}"
		noi type "`stdout'"
		di as text "{hline}"
	}
end
