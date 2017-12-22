pr drop _all
clear all
set more off
cls
global path "D:\Dropbox\Projects\stata\left_join"

set rmsg on
left_join prepare using "$path/using" , panelvar(ubigeo) timevar(t)

use "$path/master", clear

left_join join entry_region_*, panelvar(ubigeo) timevar(t) bw_left(2) bw_right(1)

set rmsg off
assert CHECK_entry_region_B73_T2==entry_region_B73_T2
exit
 
