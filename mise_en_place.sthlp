{smcl}
{* *! version 1.0.0  22dec2017}{...}
{title:Title}

{p2colset 5 12 17 2}{...}
{p2col :{cmd:mise_en_place} {hline 2}}Create project template (folders and some files){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:mise_en_place}
{it:projectname}
[{cmd:,} {opt sym:link(string)}]
{p_end}


{title:Description}

{pstd}
Create folders for a new project, as well as a few files
{p_end}

{pstd}
If the {opt sym:link} option is used, all folders except {it:data} and {it:tmp} will be created as symlinks
{p_end}
