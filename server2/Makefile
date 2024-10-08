###############################################################################
#
# MIT License
#
# Copyright (c) 2024 csBlueChip
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################

# version/variant strings
OVERS := "\"2.0.0\""
OVARS := "\"13..17\""

#------------------------------------------------------------------------------
# Parentheses and Braces        : $(makefile-varible) .. ${bash-variable}
# Set make-var from BASh output : $(eval VAR=$(shell echo value))
# Do not echo command           : @command

SHELL := /bin/bash

#------------------------------------------------------------------------------
# List of source files
SRC    := overflow.c

# Name of output file
EXE    := overflow2
EXTRAS := $(wildcard  *.i  *.o  *.s  a.out)

#------------------------------------------------------------------------------
# Tools may be different on other platforms
#
ECHO    := echo
CAT     := cat
RM      := rm
CP      := cp
MV      := mv
RMF     := $(RM) -f
SUDO    := sudo
GDB     := gdb

#------------------------------------------------------------------------------
# Some basic tools
# `xxd`  is a bidirectional hex dump util
# `cgdb` is a wrapper for `gdb` which is very nice
# `nasm` is an Intel Syntax assembler
#        ...change it to `gdb` if you prefer.
#
PACKAGES := build-essential xxd cgdb nasm
UPDATE   := $(SUDO) apt-get update
INSTALL  := $(SUDO) apt-get install

#------------------------------------------------------------------------------
LOGD   := ./logs/
LOGR   := $(shell mkdir -p $(LOGD) && mktemp ${LOGD}/log_XXXXXX)
LOGI   := $(LOGR).in
LOGO   := $(LOGR).out
LOGT   := $(LOGR).tmp

EXTRAS += [0-9]*--*  log_??????*

#------------------------------------------------------------------------------
# Compiler details
#
CC := gcc

# -g                   : include debug info
# -o0                  ; disable gcc optimisations
# -fno-stack-protector : disable stack protection
# -z exestack          ; tell linker to set +x on the Stack
CFLAGS := -g -o0 -fno-stack-protector -z execstack

#------------------------------------------------------------------------------
# "default" MUST BE THE FIRST TARGET
#
# "default" is a user-friendly feature offered by the makefile
# ...it is NOT the name of a file!
# ...therefore, it is "PHONY"
#
.PHONY: default
default: help

#------------------------------------------------------------------------------
.PHONY: help
help:
	@$(ECHO) "# all, exe, $(EXE) - build the program"
	@$(ECHO) "# run         - run the program"
	@$(ECHO) "# server      - run the program in a loop"
	@$(ECHO) "# clean       - erase crashlogs & build files"
	@$(ECHO) "# symbols     - dump the symbol table"
	@$(ECHO) "# memmap      - dump the memory map"
	@$(ECHO) "# disasm      - show disassembly"
	@$(ECHO) "# coreinfo    - extract data from coredump ID=<pid>"
	@$(ECHO) "# help        - this help"
	@$(ECHO) ""
	@$(ECHO) "# setup       - install required packages {$(PACKAGES)}"

#------------------------------------------------------------------------------
# apt-get requires sudo privs
#
.PHONY: getsudo
getsudo:
	@$(ECHO) ">> $(INSTALL) $(PACKAGES)"
	@$(ECHO) "   ...requires sudo"
	@$(SUDO) -k    # Force re-entry of (sudo) password [for security]
	@$(SUDO) true

.PHONY: setup
setup: getsudo
	$(UPDATE)
	@$(ECHO) "-----------------------------"
	$(INSTALL) $(PACKAGES)
	git clone https://github.com/csBlueChip/BuildTools.git overf1ow ;\
		overf1ow/input_parser
	$(SUDO) -k  # drop sudo privs [for security]

#------------------------------------------------------------------------------
.PHONY: clean
clean:
	$(RMF) $(EXE) $(EXTRAS)
	$(RMF) -r $(LOGD)

#------------------------------------------------------------------------------
# Friendly redirector
#
.PHONY: all
all: $(EXE)

#----------------------------------------------------------
.PHONY: exe
exe:
	@$(ECHO) "makeflags: $(MAKEFLAGS)"
	@$(RMF) $(EXE)
	@$(MAKE) --no-print-directory $(EXE) 

#----------------------------------------------------------
# The EXE will update if any of the SRC files have a 
# timestamp more recent that EXE
#
$(EXE): $(SRC) Makefile
	$(RMF) $(EXE)
	$(CC) $(SRC) $(CFLAGS) -o $(EXE) -DOVERS=$(OVERS) -DOVARS=$(OVARS)

#------------------------------------------------------------------------------
# We need to be sure `script` is complete before we parse it's output
# ...So we ensure "logging" will execute AFTER "script" is complete
#
.PHONY: run
run: script logging

#------------------------------------------------------------------------------
# This will just run `overflow` in a loop for remote attacks
#
.PHONY: server
server: $(EXE)
	@while true ; do \
		printf "\n\n" ; printf "=%0.s" $$(seq 1 70) ; printf "\n" ;\
		$(MAKE) --no-print-directory run || true ;\
	done

#----------------------------------------------------------
.PHONY: script
script: $(EXE)
	(	ulimit -c unlimited ;\
		script --return --log-in $(LOGI) --log-out $(LOGO) --flush --command "./$(EXE) 2>&1" \
	) || true

#----------------------------------------------------------
.PHONY: logging
logging:
	$(eval PID=$(shell grep 'ID:' $(LOGO) | cut -d' ' -f5 ))
	@(($(PID)0)) || $(RMF) $(LOGR) $(LOGO) $(LOGI) $(LOGT)
	@(($(PID)0))

	$(eval LOGP="$(LOGD)/$(PID)--log.txt")

	@ >$(LOGP) $(ECHO) "LOGR: $(LOGR)"
	@>>$(LOGP) $(ECHO) ""
	@>>$(LOGP) $(ECHO) "------------"
	@>>$(LOGP) $(ECHO) " Screen Log"
	@>>$(LOGP) $(ECHO) "------------"
	@>>$(LOGP) cat $(LOGO)

	@>>$(LOGP) $(ECHO) ""
	@>>$(LOGP) $(ECHO) "-----------"
	@>>$(LOGP) $(ECHO) " Input Log"
	@>>$(LOGP) $(ECHO) "-----------"

	@>>$(LOGP) $(ECHO) ""
	@`sed '1d;$$d' $(LOGI) | head -c -1 | hexdump -C | head -n -1 >>$(LOGP)`

	@>>$(LOGP) $(ECHO) ""
	@>>$(LOGP) stty -a 2>&1 || true

	@>>$(LOGP) $(ECHO) ""
	@$(eval L=$(shell stty -g | sed -E 's/([^:]*:){19}([^:]*).*/\2/'))

	@`sed '1d;$$d' $(LOGI)          \
		| head -c -1                \
		| xxd -p                    \
		| tr -d '\n'                \
		| sed 's/\(..\)/\1 /g'      \
		| sed 's/$(L) \(..\)/\1/g'  \
		| xxd -p -r                 \
		| hexdump -C                \
		| head -n -1                \
	>>$(LOGP)`

	@$(RMF) $(LOGR) $(LOGO) $(LOGI) $(LOGT)

	@# --- support for systems that use `apport` (such as lubuntu)
	@grep apport /proc/sys/kernel/core_pattern >/dev/null && \
		cp /var/lib/apport/coredump/core.*.*.*.$(PID).* core || true

	@[ -f core ] && ( \
		$(MV)  core  $(LOGD)$(PID)--core ;\
		printf "\n\nTry: \`make coreinfo ID=%s\`\n" $(PID) \
	) || true

#------------------------------------------------------------------------------
# Explore `objdump`
#
.PHONY: symbols
symbols: $(EXE)
	objdump -t $(EXE)

#----------------------------------------------------------
# Explore `/proc/<pid>/*`
#
.PHONY: memmap
memmap: $(EXE)
	$(eval PID=$(shell pgrep $(EXE)))
	@[ -z "$(PID)" ] && $(ECHO) "! $(EXE) not running" || true
	@[ -n "$(PID)" ] || false
	$(CAT) /proc/$(PID)/maps

#----------------------------------------------------------
# Examine the code that is actually being run
#
.PHONY: disasm
disasm: $(EXE)
	objdump $(EXE) -S --disassemble

#------------------------------------------------------------------------------
# Use: make coreinfo ID=<PID>
# Note the use of "\$$" to get a "$" to the gdb command line
# The prefixing `echo` causes gdb to terminate after the commands
# The suffixing `grep .` removes the colour from the gdb output
#
.PHONY: coreinfo
coreinfo: $(LOGD)/$(ID)--core
	$(eval CTMP=$(shell mktemp $(LOGD)/core_XXXXXX))
	@$(CP)  "$(LOGD)/$(ID)--core"  "$(CTMP)"
	$(ECHO) | 2>&1 $(GDB) -q \
		overflow "$(CTMP)" \
		-ex "echo -----[ info reg ]-----\n" \
		-ex "info reg" \
		-ex "echo -----[ x/16x \$$rsp-0x40 ]-----\n" \
		-ex "x/16x \$$rsp-0x40" \
		-ex "echo -----[ x/16x \$$rsp ]-----\n" \
		-ex "x/16x \$$rsp" \
	| grep .
	@$(ECHO) ""
	@$(RMF) $(CTMP)

#------------------------------------------------------------------------------
# make encrA TXT="message"
#
.PHONY: encrA
encrA:
	@i="$(TXT)";printf "char  trap[]   = \"$$(for((n=0;n<$${#i};n++));do \
		printf "\\%o" $$(((`printf "%d" "'$${i:n:1}"`^0x15)+1));done)\";\n"

#------------------------------------------------------------------------------
# make encrB TXT="message"
#
.PHONY: encrB
encrB:
	@i="$(TXT)";printf "char  detain[] = \"$$(for((n=0;n<$${#i};n++));do \
		printf "\\%o" $$(((`printf "%d" "'$${i:n:1}"`^15)));done)\";\n"

#------------------------------------------------------------------------------
.PHONY: F16
F16:
	TXT='5?Ymvzq{?<.)?kjmql?jo?l|mz~rvqx?=KWZ?]^Q[VKL?W^IZ?ZL\^OZ[?KWZVM?X^PS='
	@i="$(TXT)";printf "$$(for((n=0;n<$${#i};n++));do \
		printf "\\%o" $$(((`printf "%d" "'$${i:n:1}"`^31)));done)\n"
