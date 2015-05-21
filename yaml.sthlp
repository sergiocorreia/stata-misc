{smcl}
{* *! version 0.0.1  21may2015}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:yaml} {hline 2}}Parse a tiny subset of yaml into a mata asarray (a dict) and read from it{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 15 2}{cmd:yaml read} {it:mata_obj} {cmd:using} {it:filename.yaml}{p_end}
{p 8 15 2}{cmd:yaml local} {it:lcl}{cmd:=}{it:mata_obj.key.subkey}{p_end}
