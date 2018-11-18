
loc packages doa mise_en_place kosi hshell mata_filefilter bitfield
loc location "https://github.com/sergiocorreia/stata-misc/raw/master/src"
loc location "C:\Git\stata-misc"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}
