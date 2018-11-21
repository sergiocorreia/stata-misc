{smcl}
{* *! version 1.0.0  20nov2018}{...}
{vieweralsosee "[G-3] axis_label_options" "help axis_label_options"}{...}
{title:Title}

{p2colset 5 12 17 2}{...}
{p2col :{cmd:doa} {hline 2}}Alternative rule for selecting ticks for a plot axis{p_end}
{p2colreset}{...}

{marker syntax}{...}
{title:Syntax}

{phang2}
{cmd:pick_ticks} {varname} [, {opt n:umber(integer)} {opt v:erbose}]
{p_end}

{title:Stored results}

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:e(cmd)}}{cmd:ticks}{p_end}

{title:Example}

{hline}
{phang2}{cmd:. sysuse auto, clear}{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. pick_ticks price}{p_end}
{phang2}{cmd:. loc xticks `r(ticks)'}{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. pick_ticks weight}{p_end}
{phang2}{cmd:. loc yticks `r(ticks)'}{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. sc weight price, scheme(s2color) xlabel(`xticks') ylabel(`yticks') }{p_end}
{hline}

{title:Limitations}

{pmore} - "{ifin}" not allowed {p_end}
{pmore} - always include zero axis {p_end}
{pmore} - does not compute both axis at the same time {p_end}
