
loc packages doa mise_en_place kosi hshell mata_filefilter bitfield pick_ticks
loc location "https://github.com/sergiocorreia/stata-misc/raw/master/src"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}
