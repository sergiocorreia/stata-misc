{smcl}
{* *! version 1.1.0  248nov2018}{...}
{title:Title}

{p2colset 5 15 20 2}{...}
{p2col :{cmd:hshell} {hline 2}}hidden shell{p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:hshell}{cmd:,}
{opt cmd(string)}
[
{opt sh:ell(shelltype)}
{opt t:imeout(#)}
{opt v:erbose(#)}
]
{p_end}

{pstd}
Where {it:shelltype} is either {cmd:hidden} (default; no shell window appears),
{cmd:standard} (same as running {help shell}),
or {cmd:noisy} (standard, plus pause and no redirection).
{p_end}

{pstd}
Timeout is the maximum waiting time, in seconds.
{p_end}

{pstd}
Verbose is either 0 (default) or 1, to report detailed debugging information.
{p_end}


{title:Description}

{pstd}
Running {help shell} on Windows has the problem of always opening a terminal window,
which steals the focus away from the user. That incredible annoyance is the main reason for {cmd:hshell}.
{p_end}


{title:Requirements}

{pstd}
{cmd:hshell} requires the {cmd:parallel} package from either Github or SSC.
{p_end}
