{smcl}
{* *! version 1.0.0  17sep2014}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:monitor} {hline 2}}Notify of errors when running the command, via pushbullet{p_end}
{p2colreset}{...}

{title:Syntax - Install}

{p 8 15 2}{cmd:monitor} {opt install}{p_end}

{phang}Notes:{p_end}
{phang} - Installing will just add most of the appropiate globals in the profile.do file; you need to fill the rest{p_end}
{phang} - Remember to edit profile.do at the end{p_end}
{phang} - This requires Python to be installed, and to be callable from the terminal (i.e. its past must be in envpath).{p_end}

{title:Syntax - Usage}

{p 8 15 2}
{cmd:monitor}
[{cmd:,}
{opt note:s(str)}]
{opt device:s(str ...)}
{opt success}
{opt verbose}
{opt copy}]
{cmd: :}
{it:command}
{p_end}

{phang}Notes:{p_end}
{phang} - Default device is -mobile-{p_end}
{phang} - A global $pushbullet_DEVICE must existe for each device (define it in profile.do){p_end}
{phang} - You can use -done- instead of -success-{p_end}
{phang} - Option -copy- makes a temporary copy of the do-file so when Stata is running it (and thus the file is locked by Stata), dropbox can keep updating it{p_end}
{phang} - If you use -copy-, the command must be on the form do|run filename{p_end}
