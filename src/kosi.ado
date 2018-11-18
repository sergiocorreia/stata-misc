*! version 1.0.1 18nov2018

program define kosi
	syntax anything(name=0), [Verbose NOIsily DEBug]
	loc verbose = ("`verbose'`noisily'`debug'" != "")

	ParseVars isid  "`0'"
	ParseVars sort  "`0'"
	ParseVars order "`0'"
	ParseVars keep  "`0'"

	Run, verbose(`verbose') cmd(keep)  vars(`isid' `sort' `order' `keep')
	Run, verbose(`verbose') cmd(order) vars(`isid' `sort' `order')
	Run, verbose(`verbose') cmd(sort)  vars(`isid' `sort')
	Run, verbose(`verbose') cmd(gisid)  vars(`isid')
end


program ParseVars
	args name text
	gettoken left text : text, parse("|")
	if ("`left'"=="|") {
		loc left
	}
	else {
		gettoken pipe text : text, parse("|")
	}
	c_local `name' `left'
	c_local 0 `text'
end


program Run
	syntax, cmd(string) verbose(integer) [vars(string)]
	if ("`vars'"=="") exit
	loc cmd `cmd' `vars'
	if (`verbose') di as text "`cmd'"
	`cmd'
end
