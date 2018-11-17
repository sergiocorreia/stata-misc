clear all
set trace off
set more off
pr drop _all

loc fn1 "./tmp/foo.dta"

cap erase "`fn1'"


global sakepath "./cache"

sake, date("a" "b c" "d e") verbose: di "Hello #1"

sake, date("`fn1'"): di "Hello #1"
sake, date("`fn1'"): di "Hello #2"
sake, date("`fn1'") loc(run)
if (`run') di "Hello #3"

sysuse auto
keep price
keep in 1
save "`fn1'"

sake, date("`fn1'"): di "Hello #4"
sake, date("`fn1'") loc(run)
assert `run'==1


* sake, date("xyz.dta") cachepath(xyz): ...


* Cleanup
cap erase "`fn1'"
