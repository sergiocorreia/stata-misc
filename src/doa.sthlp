{smcl}
{* *! version 1.0.0  22dec2017}{...}
{vieweralsosee "[R] do" "help do"}{...}
{vieweralsosee "[R] doedit" "help doedit"}{...}
{title:Title}

{p2colset 5 12 17 2}{...}
{p2col :{cmd:doa} {hline 2}}Run do-file after expanding abbreviation and copying it to tempfile{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{pstd}List do-files in working directory. Includes minimal abbreviation, and links to view/edit the files:{p_end}

{phang2}{cmd:doa}{p_end}

{pstd}Run do-file:{p_end}

{phang2}{cmd:doa} {it:{help filename}} [, {opt noc:opy}]{p_end}

{pstd}Run do-file, if there are not multiple files with the same abbreviation:{p_end}

{phang2}{cmd:doa} {it:abbreviation}{p_end}


{title:Description}

{pstd}
Running {cmd:do} has two minor inconveniences:
{p_end}

{pmore}1. We have to type the entire file name{p_end}
{pmore}2. If we modify the do-file while it's running, unexpected bugs will occur{p_end}

{pstd}Using {cmd:doa} fixed both issues by autocompleting names and copying the
do-files to temporary files (which can be disabled with the {cmd:nocopy} option)
{p_end}
