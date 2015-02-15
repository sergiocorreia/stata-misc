{smcl}
{* *! version 1.0.0  17sep2014}{...}
{title:Title}

{p2colset 5 18 20 2}{...}
{p2col :{cmd:map} {hline 2}}Allow expressing multiple foreach loops as a one-liner{p_end}
{p2colreset}{...}

{title:Syntax}

{p 8 15 2}
{cmd:map}
(key=val val ...)
(...)
[{cmd:,}
{opt v:erbose}
{opt bracket:only}
{opt dry:run}]
{cmd: :}
{it:command}
{p_end}

{phang}
Note: {it:command} should contain @key expressions that will be replaced by the values of each key.
{p_end}

{phang}
Note: Inner loops are to the right; outer loops to the left.
{p_end}


{title:Examples}

Simple example:
{p 8 15 2}{cmd:sysuse auto}{p_end}
{p 8 15 2}{cmd:map (lhs=price weight) (rhs=mpg gear) (absvar=foreign turn): areg @lhs @rhs, absorb(@absvar)}{p_end}

Advanced case: verbose iterations, and wrapping values in quotes
{p 8 15 2}{cmd:map (x=1 2) (y="spam and eggs" "monty python"), verbose: di as text "x=<@x> y=<@y>"}{p_end}

Brackets are optional:
{p 8 15 2}{cmd:map (x=1 2) (y="spam and eggs" "monty python"), verbose: di as text "x=<@{x}> y=<@{y}>"}{p_end}

But on rare cases we want them to be mandatory, to deal with corner cases:
{p 8 15 2}{cmd:map (a=1 2) (abc=10 20), bracket: di as text "@{a} @{abc}"}{p_end}

{title:Multiline Commands}

If the command is longer than one line, use the advanced syntax:

{p 8 15 2}
{cmd:map}
(key=val val ...)
(...)
[{cmd:,}
{it:PreviousOptions}
{opt locals(key1 ["]val1["] ...)}
{opt run}
]
{cmd: : }{cmd:}
{p_end}
{p 12 15 2}
{it:commands}
{p_end}
{p 8 15 2}
{cmd:endmap}
{p_end}

Example:
{p 8 15 2}{cmd:map (var=turn foreign):}{p_end}
{p 12 15 2}{cmd:tab @var}{p_end}
{p 12 15 2}{cmd:su @var}{p_end}
{p 8 15 2}{cmd:endmap}{p_end}


Basically, we leave the first line empty, and use -endmap- to indicate when to stop, and add the options locals() and run, in case they are needed.
