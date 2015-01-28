// -------------------------------------------------------------
// Simple assertions (not element-by-element on variables) with informative messages
// -------------------------------------------------------------
* SYNTAX: assert_msg CONDITION , [MSG(a text message)] [RC(integer return code)]

program define assert_msg
	syntax anything(everything equalok) [, MSG(string asis) RC(integer 999)]
	* Using -asis- so I can pass strings combined with "as text|etc" keywords
	* USELESS HACK/TRICK: assert_msg 0, msg(as text "foo!") rc(0) -> Same as display
	if !(`anything') {
		if (`"`msg'"'!="") {
			di as error `msg'
			exit `rc'
		}
		else {
			di as error "assertion is false (`anything')"
			error `rc'
		}
	}
end
