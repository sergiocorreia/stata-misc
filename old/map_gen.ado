* Specialization of map.ado into a generate operation
* Supersedes transform.ado (that has name conflict with transform.class)

* Syntax: map_gen [type] newvar_pattern = exp_pattern, over(list) [format(fmt)]
* Note: If we detect *?- we expand `over' as a varlist

capture program drop map_gen
program define map_gen
	cap which map.ado
	Assert !c(rc), msg("map_gen.ado requires map.ado")
	Parse `0' // Injects: type newvar exp_pattern over format debug
	local f : subinstr local exp_pattern "@" "@{x}", all
	local newvar : subinstr local newvar "@" "@{x}", all
	qui ds
	local vars `r(varlist)'
	map (x=`over'): gen `type' `newvar' = `f'
	qui ds `vars', not
	if ("`format'"!="") format `format' `r(varlist)'

end

capture program drop Parse
program define Parse
* SYNTAX: transform [type] newvar_pat = exp_pat [if] [in] , over(list) [options]	
	Assert ("`0'"!=""), msg("-transform- needs arguments")
	* [type] newvar_pat
	gettoken newvar 0 : 0, parse("=")
	Assert strpos("`0'", "=")==1, msg("equal sign not found")
	Assert length("`0'")>1, msg("Need arguments after equal sign")
	local n : word count `newvar'
	Assert inlist(`n',1,2), msg("Syntax error in <type newvar> part")
	if (`n'>1) {
		gettoken type newvar : newvar, parse(" ")
		local is_type = inlist("`type'", "byte", "int", "long", "float", "double", "strL") | regexm("`type'", "str[0-9]+")
		Assert `is_type'==1, msg("Invalid <type>")
	}
	local newvar `newvar' // Remove leading and trailing spaces

	* Rest
	gettoken equal 0 : 0, parse("=")
	syntax anything(name=exp_pattern id="expression pattern" everything), OVER(string) [FORMAT(string)] [DEBUG]
	* Note that -in if- are allowed, but stored inside exp_pattern b/c -if- can contain @s

	* Parse varlist/stublist (older Stata may fail due to string limitations)
	if regexm("`over'", "[?*~-]") {
		unab over : `over', min(1) name("varlist to transform")
	}

	* Return results
	local params type newvar exp_pattern over format debug
	foreach x of local params {
		if ("`debug'"!="") di as text "[`x'] = [" as result "``x''" as text "]"
		c_local `x' "``x''"
	}
end

* -Assert- copied from -reghdfe-
cap pr drop Assert
program define Assert
    syntax anything(everything equalok) [, MSG(string asis) RC(integer 198)]
    if !(`anything') {
        di as error `msg'
        exit `rc'
    }
end
