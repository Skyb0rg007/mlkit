TESTFILES=fib35.sml life.sml testdyn1.sml general.sml string.sml qsort.sml fft.sml \
          tststrcmp.sml msort.sml int.sml precedence.sml simple.sml mandelbrot.sml \
          professor.sml wordcase.sml exncase.sml charcmp.sml resetregions.sml

MLBTESTFILES=multi.mlb

RESFILES=$(TESTFILES:%.sml=%.res) $(MLBTESTFILES:%.mlb=%.res) compileonly.res

MLKIT ?= SML_LIB=`pwd`/../.. `pwd`/../../bin/mlkit
BARRY ?= SML_LIB=`pwd`/../.. `pwd`/../../bin/barry

.PHONY: all
all: test

MLB/Barry/%.sml.sml: %.sml Makefile
	@echo "$(BARRY) $<" >> complog.txt
	$(BARRY) $<

%.exe: MLB/Barry/%.sml.sml Makefile
	@echo "$(MLKIT) -output $@ $<" >> complog.txt
	$(MLKIT) -output $@ $<

# An mlb-file is barified into one unit per source file, plus a unit per functor
# application; run.mlb lists them in dependency order.  Recompiling them against
# the real Basis Library checks that a name Barry prints in one unit is spelled
# the same way in the units that refer to it.
multi.exe: multi.mlb multiA.sml multiB.sml Makefile
	@echo "$(BARRY) multi.mlb" >> complog.txt
	$(BARRY) multi.mlb
	@n=`grep -c '^\./MLB/Barry/' run.mlb`; \
	  if [ "$$n" != 2 ]; then \
	     echo "*** ERR: Barry emitted $$n files for 2 source files ***"; exit 1; \
	  fi
	(echo '$$(SML_LIB)/basis/basis.mlb'; grep '^\./MLB/Barry/' run.mlb) > multi-barry.mlb
	@echo "$(MLKIT) -output $@ multi-barry.mlb" >> complog.txt
	$(MLKIT) -output $@ multi-barry.mlb

# -c compiles a file on its own and does not link, so there is no executable
# to run; check instead that the compilation unit came out as a single Core ML
# file and that the file elaborates.
compileonly.res: compileonly.sml Makefile
	@echo "$(BARRY) -c compileonly.sml" >> complog.txt
	$(BARRY) -c -namebase compileonly -output co compileonly.sml
	@n=`ls co.*.sml 2>/dev/null | wc -l`; \
	 if [ "$$n" = 1 ] \
	    && $(MLKIT) -c -no_basislib -namebase co -output co.chk co.compileonly.sml.sml >/dev/null 2>&1; \
	 then echo "Test compileonly: OK" > $@; \
	 else echo "Test compileonly: *** ERR: $$n Core ML files, or it does not elaborate ***" > $@; \
	 fi
	@cat $@
	@cat $@ >> complog.txt

%.out: %.exe
	@echo "./$< > $@" >> complog.txt
	./$< > $@

%.res: %.out Makefile
	@(diff -aq $< $*.out.ok > /dev/null 2>&1; \
         if [ $$? -eq 0 ]; then \
             echo "Test $*: OK" > $@ \
         ; else \
             if [ -e $*.out.ok ]; then \
                echo "Test $*: *** ERR: file $< differs from $*.out.ok ***" > $@ \
             ; else \
                echo "Test $*: *** ERR: file $*.out.ok does not exist ***" > $@ \
             ; fi \
         ; fi)
	@cat $@
	@cat $@ >> complog.txt

.PHONY: test
test: $(RESFILES)
	@echo "------ B A R R Y --- T E S T --- R E P O R T ------"
	@echo "Tests succeeded:   `grep "OK" $(RESFILES) | wc -l` /`grep "Test" $(RESFILES) | wc -l`"
	@echo "Test errors:       `grep "ERR" $(RESFILES) | wc -l` /`grep "Test" $(RESFILES) | wc -l`"
	@echo "See complog.txt"
	@echo "---------------------------------------------------"
	@exit `grep "ERR" $(RESFILES) | wc -l`

.PHONY: prepare
prepare:
	$(BARRY) `pwd`/../../basis/basis.mlb

.PHONY: clean
clean:
	rm -rf MLB *~ *.res *.out complog.txt run.mlb run *.exe multi-barry.mlb co.*
