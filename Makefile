#***********************************************************************
# Makefile for the offline large scale optimization with m1qn3
# in reverse communication mode.
#
# started: Martin Losch Martin.Losch@awi.de 24-Apr-2012
#
# changed: Dan Jones 16-Nov-2020 for UK ARCHER (http://www.archer.ac.uk/) 
#
# changed: Yavor Kostov 10-Oct-2022 for UK ARCHER2 (https://www.archer2.ac.uk/)
#
#***********************************************************************

# name of Makefile
MAKEFILE = Makefile

# names of the source code files for the optimization routine
SRC		=       optim_main.F			\
			optim_sub.F			\
			optim_readparms.F		\
			optim_readdata.F		\
			optim_writedata.F		\
			optim_store_m1qn3.F		\
                        m1qn3_offline.F			\
                        ddot.F                          

# default suffix for pre-processed fortran files is f
SUFF = f
# location of cpp preprocessor
CPP = cat $< | cpp -traditional -P 
##CPP = cat $< |  cpp -traditional -P $(DEFINES) $(INCLUDES) | /work/n01/n01/yavor/MITgcm/tools/set64bitConst.sh

# make depend command
MAKEDEPEND = makedepend

# libraries and include directories
LIBS            = 
INCLUDEDIRS     = -I.				\
	      	  -I/work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf 
LIBDIRS         =   

# name of executable (in current directory)
EXECUTABLE      = optim.x 

# the cpp flags 
CPPFLAGS =  -DREAL_BYTE=4		\
	-DMAX_INDEPEND=2315		\
	-D_RL='double precision'	\
	-D_RS='double precision'	\
	-D_d='d'  

# cray fortran compiler and flags (uses the 'large executable' version of linux_ia64_cray_archer)
# the byte conversion flags must match those used in the  mitgcmuv compilation
FC     =  ftn 
FFLAGS =  -fconvert=big-endian -fimplicit-none -mcmodel=medium -fallow-argument-mismatch 

# definitions
SMALLF      = $(SRC:.F=.$(SUFF))
OBJECTS     = $(SRC:.F=.o)

.SUFFIXES:
.SUFFIXES: .o .$(SUFF) .F

all: small_f $(EXECUTABLE)
$(EXECUTABLE): $(OBJECTS)
	$(FC) -o $@ $(FFLAGS) $(OBJECTS) $(LIBDIRS) $(LIBS)

small_f: $(SMALLF)

depend:
	$(MAKEDEPEND) -o .$(SUFF) $(INCLUDEDIRS) $(SRC)

# the normal chain of rules is (  .F - .f - .o  )
.F.for:
	$(CPP) $(CPPFLAGS) $(INCLUDEDIRS) > $@
.for.o:
	$(FC) $(FFLAGS) -c $<
.F.f:
	$(CPP) $(CPPFLAGS) $(INCLUDEDIRS) > $@
.f.o:
	$(FC) $(FFLAGS) -c $<

# cleaning options.
clean:
	-rm -f *.o *.f *.for

Clean:
	@make -f $(MAKEFILE) clean
	-rm -f OPWARM.*

CLEAN:
	@make -f $(MAKEFILE) Clean
	-rm -f $(EXECUTABLE)

# DO NOT DELETE

optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_OPTIONS.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/PACKAGES_CONFIG.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_OPTIONS.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEOPTIONS.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEMACROS.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/EEPARAMS.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/SIZE.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_SIZE.h
optim_sub.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/ctrl.h
optim_sub.f: optim.h m1qn3_common.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_OPTIONS.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/PACKAGES_CONFIG.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_OPTIONS.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEOPTIONS.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEMACROS.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/EEPARAMS.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/SIZE.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_SIZE.h
optim_readparms.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/ctrl.h
optim_readparms.f: optim.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_OPTIONS.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/PACKAGES_CONFIG.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_OPTIONS.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEOPTIONS.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEMACROS.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/EEPARAMS.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/SIZE.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_SIZE.h
optim_readdata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/ctrl.h
optim_readdata.f: optim.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_OPTIONS.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/PACKAGES_CONFIG.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_OPTIONS.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEOPTIONS.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CPP_EEMACROS.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/EEPARAMS.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/SIZE.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/CTRL_SIZE.h
optim_writedata.f: /work/n01/n01/yavor/MITgcm/verification/tutorial_global_oce_optim/build_taf/ctrl.h
optim_writedata.f: optim.h
optim_store_m1qn3.f: m1qn3_common.h m1qn3a_common.h mlis3_common.h
m1qn3_offline.f: m1qn3_common.h m1qn3a_common.h mlis3_common.h
