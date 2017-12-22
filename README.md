Misc Stata commands, mostly for personal use

## Installation

```stata
loc packages doa mise_en_place

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from("https://github.com/sergiocorreia/stata-misc/raw/master/")
}
```


## Local Installation


```stata
loc packages doa mise_en_place

foreach package of local packages {
	cap ado uninstall `package'
	net install `package', from("C:\Git\stata-misc")
}
```
