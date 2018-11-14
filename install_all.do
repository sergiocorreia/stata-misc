
loc packages doa mise_en_place kosi hshell mata_filefilter
loc location "https://github.com/sergiocorreia/stata-misc/raw/master/"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}
