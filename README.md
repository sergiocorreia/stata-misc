# Miscellaneous Stata commands

Production-ready commands:

- `doa`: "abbreviated do". Instead of typing `do 1_import_data` you can type `doa 1` (as long as it's unambiguous)
- `mise_en_place`: create the folder structure for a new project
- `kosi`: Shorthand for `keep order sort isid` ([details here](kosi.md))
- `hshell': hidden shell, so you can run shell commands on Windows without the annoying popups (requires the `parallel` package)

Experimental commands:

- `mata_filefilter`: alternative to filefilter implemented in Mata. Started as a workaround to an odd bug in filefilter, but might be extended further
- `block`: experiment on how to use the undocumented `_request2` option


## Installation

```stata
loc packages doa mise_en_place kosi hshell mata_filefilter
loc location "https://github.com/sergiocorreia/stata-misc/raw/master/src"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}
```


## Local Installation


```stata
loc packages doa mise_en_place kosi hshell mata_filefilter
loc location "C:\Git\stata-misc"

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from(`location')
}
```
