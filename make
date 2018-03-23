make

This article first appeared in the HPC Newsletter.
Contents

    1 Introduction to make
    2 Macros
    3 Implicit Rules
    4 Dependencies

Introduction to make

Make is a tool which is almost as old as Unix, designed primarily for keeping track of how programs are compiled.
That is what we will describe here, although it can be used for other things, including web page maintenance.
It is just a matter of telling make what commands need to be run to update your files.

Make gets its instructions from a description file, by default named makefile or Makefile. This file is also 
called the makefile, but other files can be used by invoking make with the -f option, e.g.:

 make -f Makefile.yukon

When I first got our ocean model, its Makefile looked something like:

 model: main.o init.o plot.o
  <TAB> f90 -o model main.o init.o plot.o

 main.o: main.f
  <TAB> f90 -c -O main.f

 init.o: init.f
  <TAB> f90 -c -O init.f

 plot.o: plot.f
  <TAB> f90 -c -O0 plot.f

 clean:
  <TAB> rm -f *.o core

The default thing to build is model, the first target. The syntax is:

 target: dependencies
  <TAB> command
  <TAB> command

The target model depends on the object files, main.o and friends. They have to exist and be up to date
before model's link command can be run. If the target is out of date according to the timestamp on the 
file, then the commands will be run. Note that the tab is required on the command lines.

The other targets tell make how to create the object files and that they in turn have dependencies. To 
compile model, simply type make. Make will look for the file makefile or Makefile, read it, and do 
whatever is necessary to make model up to date. If you edit init.f, that file will be newer than init.o. 
Make would see that init.o is out of date and run the f90 -c -O init.f command. Now init.o is newer than 
model, so the link command f90 -o model main.o init.o plot.o must be executed.

To clean up, type "make clean" and the clean target will be brought up to date. clean has no dependencies. 
What happens in that case is that the command rm -f *.o core will always be executed.

The original version of this Makefile turned off optimization on plot.f due to a compiler bug, but hopefully 
you won't ever have to worry about that.
Macros

Make supports a simple string substitution macro. Set it with:

 MY_MACRO = nothing today

and refer to it with:

 $(MY_MACRO)

The convention is to put the macros near the top of your Makefile and to use upper case. Also, use separate 
macros for the name of your compiler and the flags it needs:

      F90 = f90
 F90FLAGS = -O3
   LIBDIR = /usr/local/lib
     LIBS = -L$(LIBDIR) -lmylib

Let's rewrite our Makefile using macros:

 #
 # IBM version
 #
      F90 = xlf90
 F90FLAGS = -O3 -qstrict
  LDFLAGS = -bmaxdata:0x40000000

 model: main.o init.o plot.o
  <TAB> $(F90) $(LDFLAGS) -o model main.o init.o plot.o

 main.o: main.f
  <TAB> $(F90) -c $(F90FLAGS) main.f

 init.o: init.f
  <TAB> $(F90) -c $(F90FLAGS) init.f

 plot.o: plot.f
  <TAB> $(F90) -c $(F90FLAGS) plot.f

 clean:
  <TAB> rm -f *.o core

Now when we change computers, we only have to change the compiler name in one place. Likewise, if we want
to try different optimization levels, we only specify that in one place. Notice that you can use comments 
by starting the line with a #.
Implicit Rules

Make has some rules already built in. For Fortran, you might be able to get away with:

 OBJS = main.o init.o plot.o

 model: $(OBJS)
  <TAB> $(FC) $(LDFLAGS) -o model $(OBJS)

as your whole Makefile. Make will automatically invoke its default Fortran compiler, possibly f77 or g77,
with whatever default compile options it happens to have (FFLAGS). One built in rule often looks like:

 .c.o:
  <TAB> $(CC) $(CFLAGS) -c $<

which says to compile .c files to .o files using the compiler CC and options CFLAGS. We can write our own 
suffix rules in this same style. The only thing to watch for is that make by default has a limited set of 
file extensions that it knows about. Let's write our Makefile using a suffix rule:

 #
 # Cray version
 #
      F90 = f90  
 F90FLAGS = -O3
  LDFLAGS =

 .f.o:
  <TAB> $(F90) $(F90FLAGS) -c $<

 model: main.o init.o plot.o
  <TAB> $(F90) $(LDFLAGS) -o model main.o init.o plot.o

 clean:
  <TAB> rm -f *.o core

Dependencies

There may be additional dependencies beyond the source->object ones. In our little example, all our source 
files include a file called commons.h. If commons.h gets modified to add a new variable, everything must be 
recompiled. Make won't know that unless you tell it, using the syntax:

 # include dependencies

 main.o: commons.h
 init.o: commons.h
 plot.o: commons.h

Fortran 90 introduces module dependencies as well, briefly mentioned in MakeDepend.

In conclusion, make is a very powerful tool. The book to read is Managing Projects with GNU Make by 
Robert Mecklenburg, 2005, O'Reilly.

Make has a portable subset of features, with system-dependent extensions. If you want to use extensions, 


I suggest sticking with those supported by GNU make (gmake), since it is available most everywhere. 
The newest ROMS versions make use of the power of gmake and depend on it to be the make used. These more 
advanced features are described in gmake.

The most common newbie mistake is to forget that the commands after a target have to start with a tab.
Navigation menu



    
