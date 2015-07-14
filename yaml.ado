// -------------------------------------------------------------------------------------------------
// YAML parser and interface
// -------------------------------------------------------------------------------------------------
capture program drop yaml
program define yaml
	gettoken subcmd 0 : 0
	Assert inlist("`subcmd'", "read", "local", "clear"), msg("invalid subcommand (`subcmd'). Valid are: read local clear")
	yaml_`subcmd' `0'
	if ("`subcmd'"=="local") c_local `r(lcl)' `"`r(value)'"'
end

// -------------------------------------------------------------------------------------------------

capture program drop yaml_read
program define yaml_read
	syntax name(name=dict id="name of new mata object") using/ , [Verbose]
	mata: `dict' = yaml_read("`using'", "`verbose'"!="")
end

// -------------------------------------------------------------------------------------------------

capture program drop yaml_local
program define yaml_local, rclass
	Assert "`0'"!="", msg("yaml load: invalid syntax. Correct is lcl=key")

	* Parse lcl=dict.key
	gettoken lcl 0: 0 , parse("=")
	gettoken equalsign 0: 0 , parse("=")
	gettoken dict 0: 0 , parse(".")
	gettoken equalsign key: 0 , parse(".")

	* Remove blanks
	local dict `dict'
	local key `key'

	Assert "`dict'"!="", msg("yaml load: dict is empty! args=<`0'>")
	Assert "`key'"!="", msg("yaml load: key is empty! args=<`0'>")

	mata: yaml_local(`dict', "`key'")
	return local lcl "`lcl'"
	return local value "`value'"
end

// -------------------------------------------------------------------------------------------------

capture program drop yaml_clear
program define yaml_clear
	syntax name(name=dict id="name of mata object")
	mata drop `dict'
end

// -------------------------------------------------------------------------------------------------

capture program drop Assert
program define Assert
	* Copied from assert_msg.ado
	* Syntax: assert_msg CONDITION , [MSG(a text message)] [RC(integer return code)]
    syntax anything(everything equalok) [if] [in] [, MSG(string asis) RC(integer 9)]
    cap assert `anything' `if' `in'
    local tmp_rc = _rc
    if (`tmp_rc') {
            if (`"`msg'"'=="") local msg `" "assertion is false: `anything' `if' `in'" "'
            di as error `msg'
            exit `rc'
    }
end

// -------------------------------------------------------------------------------------------------
// Mata Code
// -------------------------------------------------------------------------------------------------
mata:

transmorphic yaml_read(string scalar fn, real scalar verbose) {
	fh = fopen(fn, "r")
	dict = asarray_create()

	headers = J(1, 6, "") // Up to 6 nesting levels
	oldlevel = 1
	i = 0
	hanging = 0 // 1 if prev line had key: but no value
	dict_val = ""
	while ( ( line = fget(fh) ) != J(0,0,"") ) {

		//  Ignore comments
		if ( strpos(line, "#")==1 | strlen(line)==0 ) continue
		if ( strlen(strtrim(line))==0 ) continue

		// trim right BUT NOT left
		line = strrtrim(line)

		// get level implied by indentation
		indentation = strlen(line) - strlen(strltrim(line))
		level = 1 + trunc(indentation/2)
		is_list = mod(indentation,2)
		line = strltrim(line)
		
		// deal with list "- "
		// TODO

		// Can't increase more than one level!
		if (level>oldlevel+1) {
			printf("{err}yaml_read error: level = %f but previous level was %f (%s)\n", level, oldlevel, line)
			exit(error(100))
		}

		if (hanging & level<=oldlevel) {
			printf("{err}yaml_read error: last line was hanging but level hasn't increased [line=%s]\n", line)
			exit(error(100))
		}

		_ = regexm(line, "^([a-zA-Z0-9_-]+):.*$")
		is_dict = (_!=0)

		if (is_dict) {
			dict_key = regexs(1)
			headers[level] = dict_key
			
			// Is it a hanging dict or does it follow with the value?
			dict_val = ""
			_ = regexm(line, "^([a-zA-Z0-9_-]+): *(.+)$")

			if (_!=0) {
				dict_val = regexs(2)
			}
			else {
				hanging = 1
			}
		}
		else if (hanging & level!=oldlevel+1) {
			printf("{err}yaml_read error: prev. line (old level=%f) was a hanging dict; expected a nested level (but new level=%f) or a value [line=%s]\n", oldlevel, level, line)
			exit(error(100))
		}
		else if (!hanging) {
			printf("{err}yaml_read error: line is not a dict and was not preceeded by a hanging dict (%s)\n", line)
			exit(error(100))
			557
		}
		else if (hanging) {
			dict_val = line
			--level // It was not a dict, just the value
		}

		// Add value to dict
		if (dict_val!="") {
			// Remove '' and "" quotes
			_ = regexm(line, `"^"([^"]*)"$"')
			if (_!=0) dict_val = regexs(1)

			_ = regexm(line, `"^'([^']*)'$"')
			if (_!=0) dict_val = regexs(1)

			full_key = invtokens(headers[., (1..level)], ".")

			if (asarray_contains(dict, full_key)) {
				printf("{err}yaml_read error: repeated key <%s} (%s)\n", full_key, line)
				exit(error(100))
			}

			asarray(dict, full_key, dict_val) // dict[key] = value
			if (verbose) printf("{txt}yaml <{res}%s{txt}>=<{res}%s{txt}> (level=%f)\n", full_key, dict_val, level)
			++i
			hanging = 0
			dict_val = ""
		}
		oldlevel = level
	}

	fclose(fh)
	if (verbose) {
		printf("{txt}(%s key-value pairs added to quipu metadata)\n", strofreal(i))
	}
	return(dict)
}

void yaml_local(transmorphic dict, string scalar key) {
	real scalar key_exists
	transmorphic value

	key_exists = asarray_contains(dict, key)
	assert(key_exists==0 | key_exists==1)

	if (!key_exists) {
		printf("{err}yaml_local error: key <%s> does not exist\n", key)
		exit(error(510))
	}

	value = asarray(dict, key)
	if (rows(value)>1) {
		printf("{err}yaml_local error: key <%s> has more than one row! it can only be a scalar or a rowvector\n", key)
		exit(error(510))
	}
	if (cols(value)>1) {
		value = invtokens(value)
	}

	st_local("value", value)
}
end


/* USAGE GUIDE
	yaml read mydict using somefile.yaml
	yaml local title = mydict.title
	yaml local depvar = mydict.vars.depvar.name
	
	MAYBE?
	yaml locals (somelocal = key.subkey) (...)
*/

/* YAML SYNTAX GUIDE
- We will only parse a SUB SUB set of yaml
- Case sensitive
- For now treat all values as strings (instead of numbers)
- Like Python, comments start with "#"
- Two objects: lists and dicts
- List items start with " - "
- Line breaks preserved with | (which trims spaces)
- Variables/repeated nodes
- Also json-style syntax
- Documents (start --- end ...)
- Each doc is in essence a dict

- How do we replicate a list that contains dicts?

- Indentation: two spaces

key: value
key:
  value

for now just parse this:

section:
__subsection:
____subsubsection:
______key1: value
______key2: value
section:
__a: b
__c: d

somelist:
 - item1
 - item2
somelist = [item1, item2]

object:
  key1: value
  key2: value
object = {key1: value, key2: value}
*/
