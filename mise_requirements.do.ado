*--------------------------
* Install SSC Packages
*--------------------------
	loc packages moremata boottest ivreg2 estout egenmore binscatter
	* texsave numdate mmat2tex sumup erepost winsor2 randomtag

	foreach package of loc packages {
		cap ado uninstall `package'
		ssc install `package'
	}


*--------------------------
* Install from Github
*--------------------------

	* Install misc tools
	cap ado uninstall doa
	net install doa, from("https://github.com/sergiocorreia/stata-misc/raw/master/")

	* Install ftools
	cap ado uninstall moresyntax
	cap ado uninstall ftools
	net install ftools, from("https://github.com/sergiocorreia/ftools/raw/master/src/")
	ftools, compile

	* Install gtools
	cap ado uninstall gtools
	net install gtools, from("https://github.com/mcaceresb/stata-gtools/master/build/")

	* Install reghdfe 4.x
	cap ado uninstall reghdfe
	net install reghdfe, from("https://github.com/sergiocorreia/reghdfe/raw/master/src/")
	reghdfe, compile

	* Install IV reghdfe
	cap ado uninstall ivreg2hdfe
	cap ado uninstall ivreghdfe
	net install ivreghdfe, from(https://github.com/sergiocorreia/ivreghdfe/raw/master/)

	* Install Poisson reghdfe
	* ...

*--------------------------
* Cleanup
*--------------------------
	program drop _all
	discard

exit
