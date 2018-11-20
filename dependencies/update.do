* Update -ftools- and -reghdfe- from Github
* Useful if https is blocked on Stata but not through wget on the shell

* Setup
clear all
cls
set more off
pr drop _all
global path "/ofs/research3/m1sac03/github"

* Download
!./update.sh

* Install ftools, reghdfe, and related
cap ado uninstall ftools
cap ado uninstall reghdfe
cap ado uninstall ivreghdfe

net install ftools    , from("$path/ftools")
net install reghdfe   , from("$path/reghdfe")
net install ivreghdfe , from("$path/ivreghdfe")

* Install miscellaneous stata packages
loc packages doa mise_en_place kosi hshell mata_filefilter bitfield
loc location "$path/stata-misc"
foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}

reghdfe, compile
ftools, compile

pr drop _all

ftools, version
reghdfe, version

* Other programs

cap ado uninstall gtools
net install gtools, from("$path/gtools")

cap ado uninstall sumup
net install sumup, from("$path/sumup")


* Cleanup
pr drop _all
discard

exit
