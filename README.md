# ROMS-Centos-MPI
https://github.com/pradalma/ROMS-Centos-MPI.git



Basic Steps

    Register at the ROMS website (www.myroms.org) to get access to the algorithms and other user privileges. Select a username and password which will be used in the future to login and post messages on the ROMS forum, algorithm downloads, and contributing to wikiROMS.

    Make sure that you have the following required software in your computer before attempting to compile and run an application:
        Subversion client to download source
        Fortran 90 or Fortran 95 compiler
        cpp program for C-preprocessing ROMS source code.
        GNU make version 3.81 or higher to compile ROMS
        Perl interpreter program
        NetCDF library, with Fortran 90 interface
        Message Passing Interface (MPI) library to run in parallel on a distributed-memory system

    Use a Subversion client to checkout the latest version of the ROMS trunk. It is highly recommended that you checkout the code on the same system that you will be compiling and running the code on to avoid file format issues.

    We recommend that you use the included build script to compile and link ROMS. 
    This will set up your build environment and execute the make command to build the default ROMS upwelling application. 
    This process allows you to avoid editing the makefile. Please visit the build script page for more detailed instructions.
        You can also type make at the top of the directory structure where the makefile is located but we do not recommend 
        this process because it requires changing the ROMS files which can cause conflicts when you update you ROMS code.


NoteNote: To speed compilation, you may want to add the -j <n> flag to the build command (i.e. build.sh -j 4) where <n> is the number of processors you wish to compile with. Even single processor machines can benef
it from the -j flag with <n> = 2.


NoteNote: To make sure your application can compile successfully, you might want to set USE_DEBUG to on in the build script since it will compile faster. Once your application can compile you can unset USE_DEBUG in order to create an optimized executable. Please visit the build script page for more information

     To run ROMS in serial, just type:
    oceanS < ROMS/External/ocean_upwelling.in > & log &
    or to run in parallel (distributed-memory) on two processors:
    mpirun -np 2 oceanM ROMS/External/ocean_upwelling.in > & log &
    or to run in parrallel (shared-memory) on two processors:
    setenv OMP_NUM_THREAD 2
    oceanO < ROMS/External/ocean_upwelling.in > & log &
    Here, the the file ROMS/External/ocean_upwelling.in contains all the input parameters to required by this application. Visit ocean.in for more information.

NoteNotice that in distributed-memory, the leading < is omitted so all parallel threads can read and process this input script without any communications in between. 






