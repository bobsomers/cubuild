#!/bin/env lua

--[[

cubuild is a build script to make compiling CUDA code with NVCC
easy... at least that's the idea.

You can configure more the build options if you like, but try not
to change anything under the "voodoo magic below this line" point
in the build script.

For reference, this is written in Lua. Double dashes are comments,
and double dashes with double square brackets are block comments.

Written by Bob Somers for CPE 458 at Cal Poly, San Luis Obispo.

Released under the Beerware License.
http://en.wikipedia.org/wiki/Beerware

--]]

-----------------------------------------------------------------
--     PROJECT SETTINGS                                        --
-----------------------------------------------------------------

-- Binary name (the name of the executable).
bin = "build"



-----------------------------------------------------------------
--     ENVIRONMENT SETTINGS                                    --
-----------------------------------------------------------------

-- Path to the CUDA toolkit installation.
cuda_path = "/usr/local/cuda"

-- Path to the GPU computing SDK installation.
gpusdk_path = "/opt/nvidia/gpusdk"

-----------------------------------------------------------------
--     VOODOO MAGIC BELOW THIS LINE                            --
-----------------------------------------------------------------


