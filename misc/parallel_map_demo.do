loc packages parallel_map
loc location "C:\Git\stata-misc\src"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}


clear all
cls

parallel_map, val(1 2 4) verbose maxproc(2) force: sysuse auto
parallel_map, val(10(20)40) verbose maxproc(2) force: di "HELLO"
