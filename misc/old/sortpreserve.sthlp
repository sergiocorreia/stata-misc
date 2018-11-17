{smcl}
{* *! version 1.0.0  26mar2015}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:sortpreserve} {hline 2}}Runs a command and quickly restores the sort order{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 15 2}
{cmd:sortpreserve}
{cmd: :}
{it:command}
{p_end}

{title:Example}
{p 8 15 2}{cmd:sortpreserve:} merge m:1 somevar{p_end}

{pstd}This will run merge (which potentially changes the sort order), and then
restore the sort order quickly by using the -sortpreserve- feature of Stata programming.
{p_end}

{pstd}
There are two advantages:
i) the resort is done in o(n) instead of o(n log(n)), and
ii) you save a line sorting back
{p_end}
