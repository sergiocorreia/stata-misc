{smcl}
{* *! version 1.0.0  18may2015}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:map_gen} {hline 2}}Combine -map- and -generate-{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 15 2}
{cmd:map_gen}
[{help data_types:type}] newvar_pat = exp_pat
[{cmd:,}
{opt over(list)}
[{opt format(fmt)}]

{title:Notes}

Both {it:newvar_pat} and {it:exp_pat} require a @ which will be replaced by the elements of {it:list}

The list in over will be treated as a varlist and expanded if it contains any of these three characters: ? * -

{title:Examples}

. sysuse auto
. map_gen x_@ = (turn==@), over(33 36 43) format(%2.0f)
. map_gen log_@ = log(@), over(price weight)
