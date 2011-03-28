-- Blueprint file for cubuild
-- See http://github.com/bobsomers/cubuild for more info

-- Where can I find the GPU Computing SDK?
gpu_sdk_path "/opt/nvidia/3.2/gpusdk"

-- Which configuration should be the default?
default "debug"

-- The debug build configuration.
config "debug"
    target "build-debug"
    debugging "on"
    profiling "off"
    optimizing "off"
    defines {"DEBUG"}
    flags {"Wall"}

-- The profiling build configuration.
config "profile"
    target "build-profile"
    debugging "on"
    profiling "on"
    optimizing "on"
    defines {"DEBUG"}
    flags {"Wall"}

-- The release build configuration.
config "release"
    target "build-release"
    debugging "off"
    profiling "off"
    optimizing "on"
    defines {"NDEBUG", "RELEASE"}
    flags {"Wall"}
