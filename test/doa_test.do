cls
pr drop _all
clear all
adopath + "C:\Git\stata-misc\src"
cap cd doa
dir *.do

* One file exists
doa 1, verbose
set trace off
doa "1", verbose
doa 1, verbose noc
doa 1, verbose nocopy
doa 5, verbose // spaces

* Two files exist
cap noi doa 2
assert c(rc) == 603 // cannot open file
doa 2_b

cap noi doa 3
assert c(rc) == 603
doa 3a

* No files exist
cap noi doa 4
assert c(rc) == 601 // file ____ not found


* Testing empty "doa"
doa


* Test the case where an exact match exists
doa foo

cd ..

di as text "Done!"
