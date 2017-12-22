* TODO: On linux, replace \\ with c(dirsep)
capture program drop mise_en_place
program define mise_en_place
	syntax anything(name=project) [, SYMlink(string)]
	loc path `"`c(pwd)'\\`project'"'
	di as text `"Creating a new project in the folder "`path'" "'

	loc rand = int(runiform() * 1e12)
	cap conf new file "`path'`c(dirsep)'`rand'.txt"
	_assert c(rc)==603, msg(`"Folder already exists: "`path'""') rc(603)
	mkdir "`path'"

	if ("`symlink'" != "") {
		loc sympath "`symlink'\\`project'"
		cap conf new file "`sympath'`c(dirsep)'`rand'.txt"
		_assert c(rc)==603, msg(`"Folder already exists: "`sympath'""') rc(603)
		mkdir "`sympath'"
	}

	/*
	code		Do-files
	data		Datasets created by the do-files
	docs		Information about the datasets
	input		Received raw files
	output		Regression tables, graphs, etc.
	tmp			Temporary datasets
	log			Log files
	paper		Markdown paper will be here
	*/

	loc folders code data docs input output tmp log paper
	foreach folder of local folders {
		if ("`symlink'" == "") | inlist("`folder'", "data", "tmp") {
			loc cmd `"mkdir "`path'`c(dirsep)'`folder'""'
			di as text `"  `cmd'"'
			`cmd'
		}
		else {
			loc cmd `"mkdir "`sympath'`c(dirsep)'`folder'""'
			di as text `"  `cmd'"'
			`cmd'
			loc cmd `"!mklink /D "`path'\\`folder'" "`sympath'\\`folder'""'
			di as text `"  `cmd'"'
			`cmd'
		}
	}
	
	loc folders txt tex ster figures
	foreach folder of local folders {
		mkdir "`path'`c(dirsep)'output`c(dirsep)'`folder'"
	}

	loc folders text output tmp
	foreach folder of local folders {
		mkdir "`path'`c(dirsep)'paper`c(dirsep)'`folder'"
	}

	loc code_path "`path'`c(dirsep)'code`c(dirsep)'"
	
	* Create common file headers
	loc fn "`code_path'common.doh"
	file open f using "`fn'", write text
	file write f "* Common headers and settings" _n _n
	file write f "cls" _n
	file write f "set more off" _n
	file write f "set niceness 5" _n
	file write f "set segmentsize 64m" _n _n
	file close f

	loc fn "`code_path'master.do"
	file open f using "`fn'", write text
	file write f "* Run all do-files" _n _n
	file write f "clear all" _n
	file write f "cls" _n
	file write f "set more off" _n
	file write f "log close _all" _n _n
	file write f "* do ..." _n _n
	file close f

	loc fn "`code_path'requirements.do"
	findfile mise_requirements.do.ado
 	copy "`r(fn)'" "`fn'"
	type "`fn'"

end
