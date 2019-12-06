* ===========================================================================
* Advanced demo
* ===========================================================================
	clear all
	cls

// --------------------------------------------------------------------------
// Programs
// --------------------------------------------------------------------------
program su_auto
	sysuse auto
	su price
end

program define run_regression
	sysuse auto
	reg price weight length
end

capture program drop fail
program define fail
	assert 0
end

program polynomial
	set obs 100
	gen x = _n ^ ${task_id}
	su x
end


// --------------------------------------------------------------------------
// Main
// --------------------------------------------------------------------------
	parallel_map, val(1/3) verbose maxproc(2) force prog(polynomial su_auto): polynomial
exit
	parallel_map, val(1 2 3) verbose maxproc(2) force prog(su_auto run_regression): su_auto
	parallel_map, val(1) verbose maxproc(2) force prog(su_auto run_regression fail): run_regression
	parallel_map, val(1) verbose maxproc(2) force prog(su_auto run_regression fail): fail

