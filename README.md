# cubuild

cubuild is a build script for simplifying the sometimes complex toolchain setup
and interaction between NVCC, the NVIDIA CUDA C compiler, and the system compilers
on Linux, gcc and g++.

It's written entirely in Lua, but compiles down to a single executable program
(that compiles with just gcc) that will run on any system, regardless of whether
Lua is installed using some nifty embedded Lua tomfoolery.

cubuild was written by [Bob Somers](http://bobsomers.com) for Dr. Lupo's [Applied Parallel
Computing](http://users.csc.calpoly.edu/~clupo/teaching/458/spring11/) course, CPE 458, at
[Cal Poly, San Luis Obispo](http://www.csc.calpoly.edu).

It is released under the [Beerware License](http://en.wikipedia.org/wiki/Beerware).

## Introduction

You can think of cubuild as a general build tool like `make`, only it's quite a bit smarter
about finding your source files automatically and handling the command line flags for
you. The downside is that, at this point in time, it's not particularly smart about not
recompiling things that haven't changed. It errs on the safe side and always produces a
correct build.

Just like `make` has a `Makefile` which tells it what to do, cubuild has a file called
`blueprint.lua`. (Blueprints tell you how to build things... get it?) Since cubuild itself
is written in Lua, the blueprint is just a Lua source file with some syntactic sugar to
make defining build configurations easier.

cubuild will automatically find all your source files for you, so there's no need to
constantly update your blueprint as you add and remove files from your project. The
blueprint tells cubuild *how* to build, not *what* to build. The what is defined
implicitly. cubuild will compile and link everything in your current directory and all
subdirectories (recursively) that has the following file extension:

* `*.c` (C)
* `*.cpp` (C++)
* `*.cc` (C++)
* `*.cxx` (C++)
* `*.cu` (CUDA)

On the backend, NVCC handles forwarding these files to the proper compiler and stripping
out any CUDA code for compilation by their driver. Therefore, any file that contains CUDA
kernels (`__global__` functions) or kernel launches (like `mycode<<<1, 1>>>`) needs to have
the `*.cu` extension.

In terms of directory structure, your blueprint should live at the top level (along with
cubuild if it's not in your PATH somewhere), and your source files should all be there
or in subdirectories. In other words, it should look something like this:

* blueprint.lua
* cubuild
* somefile.c
* otherfile.c
* cool\_directory/
    * coolfile.cu
    * another\_dir/
        * moar\_kernels.cu

## Running cubuild

Invoking cubuild will start the build process. You should invoke it from the same directory
your `blueprint.lua` file is in (similar to `make` and its `Makefile`).

For example, this is the output when running cubuild on the included example:

    [bsomers@helo] > cubuild
    Starting build: release
    Compiling example/cuda_code.cu
    ptxas info    : Compiling entry function '_Z3addiiPi' for 'sm_20'
    ptxas info    : Used 4 registers, 48 bytes cmem[0]
    Compiling example/main.cpp
    Compiling example/c_code.c
    Linking build-release
    Done.
    [bsomers@helo] >

This compiled 3 source files (a C file, a C++ file, and a CUDA file) into a single executable
called build-release. In particular, you'll notice that when it compiled the `add()` CUDA
kernel, it printed some information about register and constant/shared memory usage. This will be
helpful later when playing with your thread/block launch sizes.

There are currently 2 command line options, `-version` and `-verbose`. The version flag will
print information not only about the version of cubuild, but about the versions of NVCC, gcc,
and g++ that you're using as well. The verbose option replaces the friendly "Compiling x.c"
text with the actual commands being invoked in the background:

    [bsomers@helo] > ./cubuild -verbose
    Starting build: release
    nvcc -c -O2 -Xptxas -v -arch=compute_20 -code=sm_20 -DNDEBUG -DRELEASE -I/opt/nvidia/3.2/gpusdk/C/common/inc -Xcompiler -Wall -Xcompiler -ffast-math -o /home/bsomers/cubuild-0.1/example/cuda_code.o /home/bsomers/cubuild-0.1/example/cuda_code.cu
    ptxas info    : Compiling entry function '_Z3addiiPi' for 'sm_20'
    ptxas info    : Used 4 registers, 48 bytes cmem[0]
    nvcc -c -O2 -Xptxas -v -arch=compute_20 -code=sm_20 -DNDEBUG -DRELEASE -I/opt/nvidia/3.2/gpusdk/C/common/inc -Xcompiler -Wall -Xcompiler -ffast-math -o /home/bsomers/cubuild-0.1/example/main.o /home/bsomers/cubuild-0.1/example/main.cpp
    nvcc -c -O2 -Xptxas -v -arch=compute_20 -code=sm_20 -DNDEBUG -DRELEASE -I/opt/nvidia/3.2/gpusdk/C/common/inc -Xcompiler -Wall -Xcompiler -ffast-math -o /home/bsomers/cubuild-0.1/example/c_code.o /home/bsomers/cubuild-0.1/example/c_code.c
    nvcc -lm -o build-release /home/bsomers/cubuild-0.1/example/cuda_code.o /home/bsomers/cubuild-0.1/example/main.o /home/bsomers/cubuild-0.1/example/c_code.o
    Done.
    [bsomers@helo] >

If you suspect cubuild may be doing something wrong or that things aren't being compiled
correctly, have a look at the verbose output.

As expected, you can invoke `cubuild clean` to remove any generated files. It's rather
conservative, since it doesn't want to accidentally delete anything you might want to
have around. For example, it won't delete all `*.o` files, just the ones that that would
be generated by your current source files.

    [bsomers@helo] > ./cubuild clean
    Starting clean
    Removing object files
    Removing output binaries
    Done.
    [bsomers@helo] >

## Build Configurations

cubuild has the notion of a build configuration, similar to some IDEs like Visual Studio or
Eclipse. The idea behind a build configuration is that you may have several different ways
you want your program to be compiled, and it would be nice to easily switch between them.
In particular, in CPE 458 we'd like to compile our programs in a debuggable state, setup
for profiling, and a final release build with everything stripped out and the optimizer
cranked up.

You can invoke different configurations in your `blueprint.lua` by passing them along at
the command line, just like invoking a specific target with `make`:

    [bsomers@helo] > ./cubuild debug
    Starting build: debug
    Compiling example/cuda_code.cu
    ptxas info    : Compiling entry function '_Z3addiiPi' for 'sm_20'
    ptxas info    : Used 6 registers, 48 bytes cmem[0]
    Compiling example/main.cpp
    Compiling example/c_code.c
    Linking build-debug
    Done.
    [bsomers@helo] >

As you can tell from the first line of cubuild output, we're building the "debug" configuration
from our blueprint.
