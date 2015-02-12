* Main
	cls
	set more off
	set trace off

* Test assert_msg
	assert_msg 1+1==2, msg("bug")
	cap noi assert_msg 0!=0 , msg(as input "colors " as error "are " as result "good") rc(333)
	assert _rc==333
	
* Test map
	clear
	set obs 10
	gen float y = 1
	map (x=1 2 3 4 5 6), v: replace y = y * @x
	su y
	assert y==720
	clear

* Test multiline map
	global y = 0
	map (a=2 3) (b=1 2 3), run: {{
		global y = $y + @a^@b
	}}
	di $y
	assert $y==2+4+8+3+9+27
	global y
	
* Test multiline map
	sysuse auto,clear
	local left foreign
	map (right=turn rep), locals(left `left'): {{
		tab `left' @right
	}}
	
* Test -monitor-

	monitor, note("just a test") success: clear
	
	cap noi monitor, note("just a test") copy: run unit_test
	assert _rc==111
 
* Prologue
	exit
