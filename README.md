cubuild
=======

cubuild is a build script for simplifying the complex toolchain setup and
build processes for NVCC, the NVIDIA CUDA C compiler.

It's written entirely in Lua, but compiles down to a single executable
program (that compiles with gcc) that will run on any system, regardless of
whether Lua is installed using some nifty embedded Lua tomfoolery.

cubuild was written by Bob Somers for Dr. Lupo's Applied Parallel
Programming course, CPE 458, at Cal Poly, San Luis Obispo.

It is released under the Beerware License.
http://en.wikipedia.org/wiki/Beerware
