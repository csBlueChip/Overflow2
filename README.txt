!---v---v---------------------------------------------------------------------!
!	^	^--- Tabstop : 4                                             Width:79 !

===============================================================================
 Table of Contents
===============================================================================

INTRODUCTION

	#  License                - Can I copy this? [yes]
	#  TD;DR                  - `grep '^|' *.txt`
	#  Intro                  - What are buffer overflows?
	#  Caveats Preemptor      - A few questions pre-answered!
	#  Your background        - What skillz do you need?
	#  What's In It For You   - What skillz will you gain?
	#  Who am I?              - Who am I to teach this stuff?
	#  How does it work?      - Game rules
	#  WSL : WARNING          - Windows Susbsytem for Linux is broken!
	#  Walkthrough            - A solution
	#  Greetz                 - People who helped

===============================================================================
 License
===============================================================================

MIT License

Copyright (c) 2024 csBlueChip

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

 			      ___________
 			      \         /
 			       )_______(
 			       |"""""""|_.-._,.---------.,_.-._
 			       |       | | |               | | ''-.
 			       |       |_| |_             _| |_..-'
 			       |_______| '-' `'---------'` '-'
 			       )"""""""(
 			      /_________\
 			      `'-------'`
 			    .-------------.
 			jgs/_______________\
 	.

This project is released under the MIT licence (free as in "free").

That said:-
	All Issues, Feedback, Pull Requests, etc. are welcomed and encouraged.
		csbluechip@gmail.com ; @csbluechip ; github.com/csbluechip

===============================================================================
 TL;DR
===============================================================================

	# Intro                  - What are buffer overflows?
	# Caveats Preemptor      - A few questions pre-answered!
	# Your background        - What skillz do you need?
	# What's In It For You   - What skillz will you gain?
	# Who am I?              - Who am I to teach this stuff?
	# How does it work?      - Game rules
	# WSL : WARNING          - Windows Susbsytem for Linux is broken!
	# Greetz                 - People who helped

Of course, you're probably eager to start playing. 
To to get to the point ASAP, run this command:

	`make tldr`

===============================================================================
 Intro
===============================================================================

 			         _,=.=,_
 			       ,'=.     `\___,
 			      /    \  (0     |        __ _
 			     /      \     ___/       /| | ''--.._
 			     |      |     \)         || |    ===|\
 			     ',   _/    .--'         || |   ====| |
 			       `"`;    (             || |    ===|/
 			          [[[[]]_..,_        \|_|_..--;"`
 			          /  .--""``\\          __)__|_
 			        .'       .\,,||___     |        |
 			  (   .'     -""`| `"";___)---'|________|__
 			  |\ /         __|   [_____________________]
 			   \|       .-'  `\        |.----------.|
 			    \  _           |       ||          ||
 			jgs  (          .-' )      ||          ||
 			      `""""""""""""`      """         """
 	.
Buffer overflows have been the bread and butter of hackers for as long as
sloppy programmers have existed. If you see calls to strcpy(), strcat(),
sprintf(), gets(), scanf(), fread(), or one of many other library calls, you
may well have a buffer overflow exploit to play with.

In 1988, the Morris worm used a buffer overlow to infect 10% of the internet in
about 2 days** ...The buffer overflow in Phantasy Star Online [PSO] sparked the
piracy scene on the Sega Dreamcast, which ultimately lead to the death of the
Dreamcast, and Sega leaving the console market ...The SAME PSO buffer overflow
started the homebrew/piracy scene on the GameCube ...The Wii Homebrew channel
was originally installed via a buffer overflow in Zelda ...Heartbleed is 
arguably one of the most worrying security breaches of the 21st century - also
a buffer overflow ...And let's not forget WannaCry (based off Eternal Blue)
which infected over 300,000 PCs in 150 countries, brought the UK's NHS system
to it's knees, and was estiamted to have cause $4Bn (USD) in damages globally
...and these are just a few of the famous ones!

`overflow` is a CTF-styled series of vulnerabilities, all based on a single
buffer overflow.

You are provided with the source code for the server, and the developers
Makefile. We will assume we got these files from a data leak of someones
development server. In reality, the source code is probably WORSE than the
output from a decompiler such as Ida or Ghidra, and (candidly) the Makefile is
more a mechanism by which to give you clues as to what to try, what tools to
use, and how to use them - without feeding you the answers in nursery rhymes
or painfully contrived "dossiers".

The "story-line" contruct here is that we are calling upon our friends to help
get a sherrif and a deputy to capture the bandits - who we ultimately help to
escape their incarceration. And we do this by exploiting a buffer overflow
(in this case a scanf()) to make the program execute bits of code that it
would not normally execute.

In reality, instead of making a program execute:
	printf("# A friend arrives")
We would be aiming to execute something like:
	passwordIsValid = true;

Imagine a network router which allows an admin add a "port forward". What if we
could find a buffer overflow in some non-priviledged part of the code?  We may
be able to leverage the overflow to trigger the "add port forward" without
entering the admin password!

But whether the result is a "gamified" printf(), or a "realistic" security
bypass, the method of using a buffer overflow to pervert the execution sequence
of a program is the same.

-----
**I do find this statistic hilarious. Like how many computers were there in
1988? And did living-room dialup really constitute "the internet"?

===============================================================================
 Caveats Preemptor
===============================================================================

 		        ((((((((((()
 		       /  _____   /|
 		      /  /____/  /-|
 		     /          /--|
 		    /          /---|
 		   /__________/----|
 		       |-----------|
 		       |-----------|
 		   jgs '-----------'
 	.
In an attempt to try and address /some/ of the points that will undoubtedly be
raised:

Yes. There are potentially lots of ways to perform each of the breaches.
     EG. Many of the early exploits can be achieved using the later strategies.

Yes. I will take you through ONE possible solution.
     ...One that has been crafted to reveal a diverse set of 'h4x0r skillz'.

Yes. We are all interested to hear about your "much better way to do it"
     ...and look forward to seeing and following your walkthrough. PoC||GTFO.

No.  You do NOT need to follow the game rules.
     EG. "You must type `make run` or `make server` to run the program."
     But, obviously, if you're playing a personally tailored version of The
     Game**, you can make up any rules you want !-)

Yes. You are encouraged to share finer detail when I over-simplify some
     issue of which you are a Subject Matter Expert.

Yes. I have almost certainly, beyond typos and grandma erros, made technical
     mistakes, and I am happy to be corrected on matters of fact.
     On matters of opinion, I'd love to hear your thoughts, but I reserve the
     right to (at my discretion) either change or keep my original opinion.

Yes. I know what Stack Canaries are.
No.  I will not be addressing them in this 'beginners' guide'.
     But you will be pleased to know we will be looking at ASLR.

[**] And for an encore, I will tell you that Kellogs make Blue Waffles!

===============================================================================
 Your background
===============================================================================

 		               __.............__
 		       .--""```                 ```""--.
 		        ':--..___             ___..--:'
 		          \      ```"""""""```      /
 		        .-`  ___.....-----.....___  '-.
 		      .:-""``     ~          ~    ``""-:.
 		     /`-..___ ~        ~         ~___..-'\
 		    /  ~    '`""---.........---""`        \
 		   ;                                       ;
 		  ; '::.   '          ~     .:'    _.       ;
 		  |   ':::    '            .:'           ~  |
 		  |~  .:'   .      _        ':.             |
 		  | .:'                       ':.~          |
 		  |  ':.      .  ~     .    _   .:          |
 		  ; '::.             _     /|| .;'          ;
 		   ;    ':          ( }    \||D            ;
 		    \.:'.:':.     | /\__,=_[_]            /
 		     \ ':.     ~  |_\__ |----|      `    /
 		      '. '::..  _ |  |/ |--. |_      ~ .'
 		        '-._':'   |  /_ |    |  `'-_.-'
 		    jgs    (``''--..._____...--''``)
 		            `"--...__     __...--"`
 		                     `````
 	.
Useful skills to have before you start are:

# SOME experience of programming - preferably in C or a C-style language.
	If you don't know what a function or a loop is, you are way out of your
	depth.

# Some knowledge of what a Stack is, and the basic principle of how they
	(FIFO buffers) work. If not, enjoy this URL:
	https://html-preview.github.io/?url=https://github.com/csBlueChip/6502_Programming_Guide/blob/master/6502.htm#STACK_WHAT:~:text=The%20Stack%20%2D%20What%20Is%20It%3F%20%C2%A0%C2%A0
	|-----------------------------------|-----------------|----------|----------------------|--------------------|---------------------------------------------------------------------|

# The ability to spot (simple) patterns in groups of numbers.
	If two (long) numbers are very similar, maybe they are related!

# Knowledge of a counting bases other than decimal.
	You should be able to understand that (eg) 0x10 and 16 are the same value.

# The drive to succeed when things are new, and therfore difficult.
	I've tried to drop helpful breadcrumbs, but I have NOT "fed you the
	answers".

# Willingness to work as a team
	If you're truly L33t, then by all means work alone. Otherwise, remember:
	"If one person has the courage to ask a question, you can bet ten people
	want to hear the answer!" ...Your learn more, and remember more if you
	share your ideas with others, who are also sharing their ideas with you!
	[prove me wrong]

===============================================================================
 What's In It For You
===============================================================================

 		       .--_....._-------,
 		      / .'       '.    /|
 		     / / N U K E S \  / |
 		    /  '._       _.' /  |   "Do not press this button again"
 		   /      ```````   /  /                     [Heart of Gold]
 		   |----------------| /
 		   |                |/
 		   '----------------'
 	.
If you follow this through, what will you learn about?

	Code obfuscation
		The FIVE common counting bases
		How to read code, and what you can safely ignore
		Unwrapping deliberate obfuscation
		Spotting obfuscation resulting from poor programming skills

	Makefiles
		What are they and how do they work?
		Why are they important?
		What can they tell us; what can they hide?
			https://research.swtch.com/xz-script#:~:text=The%20shell%20code%20during%20make%20adds%20the%20object%20file%20to%20the%20build

	Memory alignment
		Understading memory-aligned variables
		...and memory-aligned (or lack thereof) instructions

	Memory organisation and corruption
		Buffer overflows
		"Stack smashing"
		Address Space Layout Randomisation [ASLR]
		Position Independent Code [PIE]

	Program flow
		What is the Program Counter (aka Instruction Pointer)
		How can we take control of it

	Programming
		A (VERY) brief intro to (x64) assembler
		Injecting code in to running programs

	Return Oriented Programming
		The BASICs ot RoP atacks (euphemistically: "Return To C")
		...you will implement a couple of trivial RoP attacks

	Cryptography
		Analysing & reproducing (SIMPLE) "roll your own" crypto

	Static and Dynamic Analysis
		Static  - things that don't change ...The code, the exe, etc.
		Dynamic - things that  do   change ...Memory layout, System IDs, etc.

	Side-channel attacks
		Analysing data that is an EFFECT of running the code

	Full remote shell access to the target server!

Make this your focus:
	* If an attack succeeds, it means that either you knew something, or
	  you just intuited something new from what you've learned previously.
	* If an attack fails, understanding WHY it failed means you just
	  learned something new.

===============================================================================
 Who am I?
===============================================================================
 		                 ___
 		                / ,-\      _ ___
 		               | (  '\    |-|   |._
 		        ___     )_ _/     | |   |  |
 		       [___]   /  `\____  | |   |_.'
 		       |  ^|  /  \_____/) |-|___|
 		       |   | /    /   _:::_))_(___
 		       |   |/'-._/_   |___________|
 		       '-;_|\_____ `\ ||"""""""""||
 		         | `######|_|_||         ||
 		         \ ._  _,'{~-_}|         ||
 		         _)   (   {-__}|         ||
 		    jgs /______`\ |_,__)         ||
 	.
I come from a hardware background, and we are required to juggle a range of
skills. Like your local GP (General Practitioner/Family Doctor) we need to have
memorised the Table-of-Contents of "The Big Book of Things [<your trade>
edition]", and we have to have some insight in to each subject. We each have
'one or two' things in which we "specialise", we know our limits, and we simply
HAVE TO work as a team - which sometimes requires identifying the nature of the
issue, and passing it on to a Subject Matter Expert.

The Internet of Sh!te [IoT] is swamped with out-of-date hardware, running code
written by programmers with little-or-no understading of how hackers think,
using ancient development kits, and working to unreasonable deadlines. Which
inevitably results in any number of horrible and often historic/persistent
vulnerabilities.

The first comment I get is going to be: "What about stack canaries? I see
you've explicitly disabled them!" ...To whit I proffer: "The IoT world is so
out of date, these sort of things are still YEARS away from being relevant to
a hardware/embedded hacker." ...What you discover here is TOTALLY realistic,
and will continue to be so for MANY years to come!

===============================================================================
 How does it work?
===============================================================================
 	                          _
 	              .----------/ |<=== floppy disk
 	             /           | |
 	            /           /| |          _________
 	           /           / | |         | .-----. |
 	          /___________/ /| |         |=|     |-|
 	         [____________]/ | |         |~|_____|~|
 	         |       ___  |  | |         '-|     |-'
 	         |      /  _) |  | |           |.....|
 	function ======>|.'   |  | |           |     |<=== application
 	  key    |            |  | |    input  |.....|       software
 	         |            |  | |            `--._|
 	  main =>|            |  | |      |                 de-bugging   ||
 	 storage |            |  | ;______|_________________   tool ====>||
 	         |            |  |.' ____\|/_______________ `.           ||
 	         |            | /|  (______________________)  )<== user  ||
 	         |____________|/ \___________________________/  interface||
 	         '--||----: `'''''.__                      |             ||
 	            || jgs `""";"""-.'-._ <== normal flow  |    central  ||
 	            ||         |     `-. `'._of operation /<== processing||
 	            ||         |        `\   '-.         /       unit    ||
 	  surge     ().-.      |         |      :      /`                ||
 	control ==>(_((X))     |      .-.       : <======= output        ||
 	 device       '-'      \     |   \      ;     /_________       .-''-.
 	                        `\  \|/   '-..-'      |   /_\  /|     /______\
 	                         /`-.____             |       / /      [____]
 	                        / _     /_____________| _    / /_
 	          peripherals ==>/_\___________________/_\__/ /~ )__
 	            (hardware) |____________________________|/  ~   ) |\\\ ///|
 	                                            (__~  ~     ~(~~` | \\V// |
 	          overflow (input/output error) ===> (_~_  ~  ~_ `)   |  |~|  |
 	      _________                                  `--~-' '`    |  |=|  |
 	   _|`---------`|                       supplemental data ===>|  | |  |
 	  (C|           |<=== back-up        (()____                  |  | |  |
 	   `\           /                   ('      `\______,          \ |=| /
 	     `=========`           mouse ==> `,,---,,'                  \|_|/
 	.

,-----------------------------------------------------------------------------.
| ,-------------------------------------------------------------------------. |
| |                                                                         | |
| |  Do this once:                                                          | |
| |     Grab 'overflow.c' and 'Makefile' from the repo.                     | |
| |     Run `make setup` to check you've got all the tools you may need.    | |
| |     Namely: {build-essential, xxd, cgdb, nasm}                          | |
| |                                                                         | |
| |  Based on which challenge you are attempting:                           | |
| |     Friends #1  to #12 :  `make server1`                                | |
| |     Friends #13 to #16 :  `make server2`                                | |
| |                                                                         | |
| |  Then do this repeatedly:                                               | |
| |     1) Input your game "mode"                                           | |
| |     2) Input your friend's "name"                                       | |
| |     3) See if your friend turns up (and agrees to help).                | |
| |                                                                         | |
| `-------------------------------------------------------------------------' |
`-_                        ,----------------------.                         _-'
   `.                     |(x)    The Rulez   (+)|                        .' 
    |                      `----------------------'                       |
    `---------------------------------------------------------------------'

Footnotes
---------

ALL these attacks rely on the same buffer overflow.
But the choice of input you use in the overflow gets [if I've judged it well]
gradually more and more advanced.

The way I see it, the "Friends" are in FIVE groups:
	 1.. 6 - Input device manipulation (keyboard)
	 7.. 9 - Controlling Program Flow
	10..12 - Memory Analysis
	13..15 - Code Injection
	16..17 - Jailbreak

You are HEAVILY encouraged to use ANY tools you desire to work out the
solutions; edit the source code; patch the Makefile; use a non-standard
compiler; etc. ...There a NO RULES AT ALL about how you work out the solutions.
...BUT: Solutions ONLY count if you can ultimately reproduce your attacks
        under 'game conditions'

I suggest you perform the first SIX challenges by physically entering the 
'mode' and 'name' on a real keyboard. After which I suggest you write a trivial
tool - in 'C' or BASh, it can be done with about 20..30 lines of code.

==PS==
Apparently people have found this (keyboard) part so difficult, they have given
up.  Yes. It IS possible. No. It is (likely) NOT soemthing you already know.
...I have had to solve this problem now on two operating systems, and two bits
of hardware, meaning I had to solve the problem three times. And each solution
is VERY different from the others. You can only begin to imagine how much I
learned about the (keyboard) input system while I was researching THAT! But I
know there are more solutions (that need) to be found!

===============================================================================
 WSL : WARNING
===============================================================================

On the 24/Oct/2016 stakemura reported to Microsoft that WSL does not produce
coredump files. This has never been fixed. [June 2024]
	https://github.com/microsoft/WSL/issues/1262

As such, you cannot debug ANY program post-segfault under WSL !

This set of challenges can definitely be solved without coredumps,
but it is (debatably) going to be a LOT harder.

I can only suggest you install a hypervisor (such as VirtualBox or VMWare), 
and install Debian.

===============================================================================
 Walkthrough
===============================================================================

A comprehensive walkthrough of the entire CTF has been written:

	$>wc -l *.txt
	   488 _01_INTRO.txt [you're reading it now]
	   295 _02_REVIEW_OVERFLOW.txt
	   373 _03_REVIEW_MAKEFILE.txt
	   380 _04_FRIENDS_01to06.txt
	   438 _05_TYPING_THE_UNTYPABLE.txt
	   406 _06_KEY_STUFFER.txt
	   648 _07_FRIENDS_07to09.txt
	   717 _08_FRIENDS_10to12.txt
	   339 _09_EXPLAIN_EASY_CODE.txt
	  1264 _10_FRIENDS_13to15.txt
	   734 _11_FRIENDS_16to17.txt
	   467 README.txt
	  6549 total

...complete with a library of handy functions, and an autopwn script which can
summon 17 of the 18{*1] challenges in ~21s[*2] ...The last challenge cannot be
timed, you will understand why when you see it.

So you can be sure the whole process is proven, and the results are repeatable.

[*1] Yes, 18
[*2] Single core VM, servers running locally

===============================================================================
 Greetz
===============================================================================

 	 ____   ____   ____   ____   ____   ____   ____
 	||G || ||R || ||3 || ||3 || ||T || ||Z || ||@ ||   en4rab
 	||__|| ||__|| ||__|| ||__|| ||__|| ||__|| ||__||   madtroll
 	|/__\| |/__\| |/__\| |/__\| |/__\| |/__\| |/__\|
 	.
===============================================================================
 EOF
===============================================================================
