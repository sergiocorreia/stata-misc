program define sortpreserve, sortpreserve
	* Parse colon
	_on_colon_parse `0'
	local cmd `s(after)'
	local 0 `s(before)'
	`cmd'
end
