**** Programs used by ...


* 1) SSC
	loc packages numdate egenmore mmat2tex estout texsave rangestat moremata winsor winsor2 unique // listtab rsource 

	foreach package of local packages {
		cap ado uninstall `package'
		ssc install `package'
	}


* 2) Github
	loc wd "`c(pwd)'"
	cd "/ofs/research3/m1sac03/github"
	do "update.do"
	cd "`wd'"
	cap erase "./ssc_results.smcl" // not sure if this is still needed

exit
