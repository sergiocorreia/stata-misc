{smcl}
{* *! version 1.0.0  18nov2018}{...}
{title:Title}

{p2colset 5 12 17 2}{...}
{p2col :{cmd:bitfield} {hline 2}}Collapse group membership using bitfields{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{pstd}Pack a bitfield from a variable, by 1+ variables:{p_end}

{phang2}
{cmd:bitfield}
{cmd:pack}
{it:bitfield_name}
[{it:if}]
{cmd:,}
{opth input:var(varlist:variable)}
{opth by(varlist)}
[{opt v:erbose}]
{p_end}

{pstd}Unpack values from bitfield:{p_end}

{phang2}
{cmd:bitfield}
{cmd:unpack}
{it:bitfield_name}
{cmd:,}
{opth gen:erate(newvar)}
{opt value(#)}
[{opt replace}
{opt v:erbose}]
{p_end}

{pstd}Describe bitfield (also see {cmd:char list}):{p_end}

{phang2}
{cmd:bitfield}
{cmd:describe}
{p_end}

{title:Description}

{pstd}
Collapse, in a memory-efficient way, membership information within groups
{p_end}

{marker examples}{...}
{title:Examples}

{pstd}
Note that turn==42 appears for some domestic cars; turn==49 never appears
{p_end}

{hline}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{p_end}
{phang2}{cmd:. tab turn foreign}{p_end}
{phang2}{cmd:. bitfield pack BF, input(turn) by(foreign)}{p_end}
{phang2}{cmd:. list}{p_end}
{phang2}{p_end}
{phang2}{cmd:. bitfield unpack BF, gen(has_42) val(42)}{p_end}
{phang2}{cmd:. bitfield unpack BF, gen(has_49) val(49)}{p_end}
{phang2}{cmd:. list}{p_end}
{hline}
