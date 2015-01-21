{smcl}
{* *! version 1.0.0  17sep2014}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:monitor} {hline 2}}Notify of errors when running the command, via pushbullet{p_end}
{p2colreset}{...}

{title:Syntax}

Installing (open profile.do)
{cmd:monitor} {opt install}

{p 8 15 2}
{cmd:monitor}
[{cmd:,}
{opt note:s(str)}]
{opt DEVICE:s(str ...)}]
{opt SUCCESS}]
{cmd: :}
{it:command}
{p_end}

Default device is mobile, default status is error

{phang}
Note that this assumes a Python installation with the proper modules, and the existence of a .py file
{p_end}

