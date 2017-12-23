* Same as -do- but with autocomplete

capture program drop doa
program define doa
	syntax anything(name=pattern), [Verbose]

	* List all filenames with this pattern
	loc pattern "`pattern'*.do"
	loc dofiles : dir "." files "`pattern'", respectcase
	loc numfiles : list sizeof dofiles
	
	_assert `numfiles' != 0, msg(`"No files match the pattern "`pattern'""')
	_assert `numfiles' == 1, msg(`"More than one file matches the pattern "`pattern'""')
	loc dofile `dofiles'

	tempfile tempdo
	copy "`dofile'" "`tempdo'"
	if ("`verbose'"!="") di as text `"(running <`dofile'> as <`tempdo'>)"'
	do "`tempdo'"
end
