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
