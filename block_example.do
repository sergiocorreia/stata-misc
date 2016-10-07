cls
discard

tempfile template
tempfile replaced

block, file("`template'") verbose
	lorem ipsum
	dish=@food
	drink=@drink
	done!
endblock

set trace off
set more off

tempfile replaced
foreach food in spam bacon eggs {
	foreach drink in coke beer {
		blockreplace, infile("`template'") outfile("`replaced'") ///
			loc(food `food' drink `drink') v
	}
}
