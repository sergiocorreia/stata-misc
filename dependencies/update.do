* Update -ftools- and -reghdfe- from Github
* Useful if https is blocked on Stata but not through wget on the shell

* Setup
clear all
cls
set more off
pr drop _all

* Download
!./update.sh


* ftools/reghdfe
cap ado uninstall ftools
cap ado uninstall reghdfe
cap ado uninstall ivreghdfe

net install ftools    , from("MYPATH/ftools")
net install reghdfe   , from("MYPATH/reghdfe")
net install ivreghdfe , from("MYPATH/ivreghdfe")

reghdfe, compile
ftools, compile

pr drop _all

ftools, version
reghdfe, version

* Other programs

cap ado uninstall gtools
net install gtools, from("MYPATH/gtools")

cap ado uninstall sumup
net install sumup, from("MYPATH/sumup")


* Cleanup
pr drop _all
discard

exit
