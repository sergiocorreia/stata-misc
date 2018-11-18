/* BENCHMARK

use "E:\Projects\cc\data\credit\monthly\cc\201412.dta", clear
set rmsg on
tab bank if status==0
bitfield pack bank_bf if status==0, by(deudor) input(bank) v
bitfield unpack bank_bf, gen(has_bcp) val(1)
tab has_bcp

packs a 250mb file with 8mm obs in 3.3s (!)
unpacks in 0.5s (!)

As a comparison, the tabulate took 0.7s

*/

clear all
cls

loc location "C:\Git\stata-misc\src"
cap ado uninstall bitfield
net install bitfield, from(`location')

* Test 1


loc k 100
set obs `k'
gen i = 1
gen j = _n
drop in 7

bitfield pack BF, input(j) by(i) v
li
loc kk = `k' + 1
forv i=0/`kk' {
*di as error "..`i'"
bitfield unpack BF, gen(has_`i') val(`i') // v
}
li


* Test 2

sysuse auto, clear

set trace off
tab turn foreign, matcell(freqs)
mata: has_bench = st_matrix("freqs") :> 0

bitfield pack BF, input(turn) by(foreign) v

de
char list
bitfield describe BF
bitfield unpack BF, gen(has42) val(42) v
bitfield unpack BF, gen(has100) val(100) v
li

cap drop has*
forv i=1/100 {
	bitfield unpack BF, gen(has`i') val(`i')
}
egen empty = rowtotal(has1-has30 has52-has100)
assert empty==0
drop has1-has30 has52-has100 empty
drop has47 has49 has50
mata: has_check = st_data(., "has*")'
mata: assert(has_bench == has_check)

* Test 3 (use if)

li foreign BF*
sysuse auto, clear
bitfield pack BF if foreign, input(turn) by(foreign)
li




// --------------------------------------------------------------------------
// Old test code
// --------------------------------------------------------------------------


exit

// -------------------------------------------------------------



* CREATE TEST DATASET AND TEST COMMAND

* Construct test dataset
	clear all
	qui adopath + "D:/Dropbox/Projects/stata/bitfield"
	qui adopath + "D:/Dropbox/Projects/stata/misc"
	
	set more off
	timer clear
	set obs `=1e5'

	gen long deudor = min(1, (_n==1) + uniform()<0.2)
	replace deudor = sum(deudor)

	bys deudor: gen byte bank = 1+int(100* int(uniform()*41)/41 )
	assert !missing(bank+deudor)
	bys deudor bank: keep if _n==1
	*keep if bank<=40
	levelsof bank

* Test creation
	cou
	bitfield create bank if bank>10, by(deudor) prefix(mask) debug
	compress
	cou
	* by deudor: keep if _n==1
	de
	su mask__*
	* Don't do a tab on any mask b/c ANY value between 1 and 2^numvalues is possible!
	char list
	
	set obs `=c(N)+1'
	
	bitfield describe mask
	
* Test usage
	* Not found
	cou
	bitfield contains 3, prefix(mask) varname(test)
	cou
		tab test, m // check that one missing is there
	bitfield contains 13, prefix(mask) varname(test)
		tab test, m
		drop if missing(bank)
		tab test if bank==13
		gen byte tmp = (bank==13)
		bys deudor: egen byte debug = max(tmp)
		tab test debug, m
		char list

	bitfield contains 79, prefix(mask) varname(test)
	bitfield contains 98, prefix(mask) varname(test)
	
exit


