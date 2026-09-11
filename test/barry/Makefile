TESTFILES=fib35.sml life.sml testdyn1.sml general.sml string.sml qsort.sml fft.sml \
          tststrcmp.sml msort.sml int.sml precedence.sml simple.sml mandelbrot.sml \
          professor.sml wordcase.sml exncase.sml charcmp.sml

MLBTESTFILES=multi.mlb

RESFILES=$(TESTFILES:%.sml=%.res) $(MLBTESTFILES:%.mlb=%.res)

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
	(echo '$$(SML_LIB)/basis/basis.mlb'; grep '^\./MLB/Barry/' run.mlb) > multi-barry.mlb
	@echo "$(MLKIT) -output $@ multi-barry.mlb" >> complog.txt
	$(MLKIT) -output $@ multi-barry.mlb

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
	rm -rf MLB *~ *.res *.out complog.txt run.mlb run *.exe multi-barry.mlb
