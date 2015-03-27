// -------------------------------------------------------------
// Simple assertions (not element-by-element on variables) with informative messages
// -------------------------------------------------------------
* SYNTAX: assert_msg CONDITION , [MSG(a text message)] [RC(integer return code)]
* Tricks:
* - Using -asis- allows me to pass strings combined with "as text|etc" keywords
*	EG: ... msg("variable " as result "`var'" " is missing")
*	I could use {res} and so on, but those have limits
* - Note that assert_msg 0, msg(as text "foo!") rc(0) -> Same as display

program define assert_msg
	syntax anything(everything equalok) [if] [in] [, MSG(string asis) RC(integer 9)]
	cap assert `anything' `if' `in'
	local tmp_rc = _rc
	if (`tmp_rc') {
		if (`"`msg'"'=="") local msg `" "assertion is false: `anything' `if' `in'" "'
		di as error `msg'
		exit `rc'
	}
end
