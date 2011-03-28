-- Blueprint file for cubuild
-- See http://github.com/bobsomers/cubuild for more info

-- Where can I find the GPU Computing SDK?
gpu_sdk_path "/opt/nvidia/3.2/gpusdk"

-- Which configuration should be the default?
default "debug"

-- The debug build configuration.
config "debug"
    output "build-debug"
    debugging "on"
    profiling "off"
    optimizing "off"
    defines {"DEBUG"}

-- The profiling build configuration.
config "profile"
    output "build-profile"
    debugging "on"
    profiling "on"
    optimizing "on"
    defines {"DEBUG"}

-- The release build configuration.
config "release"
    output "build-release"
    debugging "off"
    profiling "off"
    optimizing "on"
    defines {"NDEBUG", "RELEASE"}
    includes {"my/special/incs", "your/incs"}
    cflags {"-Wall", "-ffast_math"}
    libdirs {"my/libs", "your/libs"}
    libs {"m", "boost_regex"}
    lflags {"-m64"}
