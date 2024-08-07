SHELL=/bin/bash
MAKES=make --no-print-directory -C

#-'"`-~,_/""`~~,.|""`;,,/"\-'"`-'"`-~,_/""`~~,.|""`;,,/"\-'"`-'"`-~,_/""`~~,.-_
#~._.~-'"\__,--'`|__.;''\_,~._.~._.~-'"\__,--'`|__.;''\_,~._.~._.~-'"\__,--'`-

.PHONY: help tldr setup

#------------------------------------------------------------------------------
help:
	@echo "tldr     - show (only) essential instructions"
	@echo "setup    - install (common) basic tools [uses apt-get]"
	@echo "compare  - compare servers code"

#------------------------------------------------------------------------------
tldr:
	@grep '^|' README.txt

#------------------------------------------------------------------------------
setup:
	@$(MAKES) server1 setup

#-'"`-~,_/""`~~,.|""`;,,/"\-'"`-'"`-~,_/""`~~,.|""`;,,/"\-'"`-'"`-~,_/""`~~,.-_
#~._.~-'"\__,--'`|__.;''\_,~._.~._.~-'"\__,--'`|__.;''\_,~._.~._.~-'"\__,--'`-

.PHONY: help2  clean clean1 clean2  exe exe1 exe2  run1 run2  server1 server2

#------------------------------------------------------------------------------
help2:
	@echo "clean    - cleanup both servers"
	@echo "clean1   - cleanup server 1"
	@echo "clean2   - cleanup server 2"
	@echo ""
	@echo "exe      - build both servers"
	@echo "exe1     - build server 1"
	@echo "exe2     - build server 2"
	@echo ""
	@echo "server1  - run server 1"
	@echo "server2  - run server 2"
	@echo ""
	@echo "copy1to2 - create server2 from server1"
	@echo "compare  - compare servers code"

#------------------------------------------------------------------------------
clean: clean1 clean2

exe: exe1 exe2

#------------------------------------------------------------------------------
exe1:
	${MAKES} server1 clean all

clean1:
	${MAKES} server1 clean

run1:
	${MAKES} server1 run

server1:
	${MAKES} server1 server

#------------------------------------------------------------------------------
exe2:
	${MAKES} server2 clean all

clean2:
	${MAKES} server2 clean

run2:
	${MAKES} server2 run

server2:
	${MAKES} server2 server

#------------------------------------------------------------------------------
copy1to2:
	./srv1to2.sh

#------------------------------------------------------------------------------
compare:
	@printf "%.0s=" `seq 1 106` ; echo
	diff --color  server1/Makefile    server2/Makefile    ||:
	@printf "%.0s=" `seq 1 106` ; echo
	diff --color  server1/overflow.c  server2/overflow.c  ||:
	@printf "%.0s=" `seq 1 106` ; echo

