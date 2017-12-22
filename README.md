Misc Stata commands, mostly for personal use

## Installation

```stata
net from 

loc packages doa

foreach package of local packages {
	cap ado uninstall `package'
	net install package, from("https://raw.githubusercontent.com/sergiocorreia/stata-misc/master/")
}
```
