#!/bin/bash

#
# This creates server2 from server1
# It just makes it easier to synch code changes
#
# IT REALLY IS OF NO INTEREST TO SOLVING `overflow`
#
# IF YOU WANT TO SEE WHAT IT DOES:-
#   1) Run it
#   2) `make compare`
# ... And prepare to be underwhelmed!
#

## --- Makefile ---
# change version number
# change name of exe
# add -z execstack       <-- THIS is the only relevant change!
#
cat server1/Makefile \
	| sed -e 's/1\.\.12/13\.\.17/' \
	      -e 's/overflow1/overflow2/' \
	      -e 's/^\(CFLAGS.*\)$/\1 -z execstack/' \
	>server2/Makefile

## --- overflow.c ---
# Change the text for Friends #7..12 to say "doesn't turn up"
#
: << EOF
<#9
> doesn\'t turn up\\n
<#8
> doesn\'t turn up\\n
<#%s
> doesn\'t turn up\\n
<#7
> doesn\'t turn up\\n
<p)]
>
-charisma
-answer-0131
-ruff
-moving
EOF

in=server1/overflow.c
out=server2/overflow.c

cp $in $out

while IFS= read -r l || [[ -n $l ]] ; do
	if [[ ${l::1} == "<" ]] ; then
		old="${l:1}"

	elif [[ ${l::1} == ">" ]] ; then
		new="${l:1}"
		echo "FIX-UP : $old"

		if [[ ${old::1} == "#" ]] then 
			sed -i "s/^\(.*${old}\).*\(\".*\)/\1${new}\2/" $out
		else  #                        v-^
			sed -i "s/^\(.*${old}\).*\(.*\)/\1${new}\2/" $out
		fi

	elif [[ ${l::1} == "-" ]] ; then
		del="${l:1}"
		echo "DELETE : $del"
		sed -i "/$del/d" $out

	fi
done < <(grep '^[<>-]' $0)
