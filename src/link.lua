-- handles the linking phase

function link(files)
    local cmd = "nvcc"

    -- profiling?
    if configs[chosen_config].profiling then
        cmd = table.concat {cmd, " -pg"}
    end

    -- gpu computing sdk libdir
    cmd = table.concat {cmd, " -L", sdk_path, "/C/lib"}

    -- library directories
    for _, val in ipairs(configs[chosen_config].libdirs) do
        cmd = table.concat {cmd, " -L", val}
    end

    -- gpu computing sdk cutil library
    cmd = table.concat {cmd, " -lcutil_x86_64"}

    -- libraries
    for _, val in ipairs(configs[chosen_config].libs) do
        cmd = table.concat {cmd, " -l", val}
    end

    -- linker flags
    for _, val in ipairs(configs[chosen_config].lflags) do
        cmd = table.concat {cmd, " -Xlinker ", val}
    end

    -- output executable name
    cmd = table.concat {cmd, " -o ", configs[chosen_config].output}

    -- object files
    for _, v in ipairs(files) do
        cmd = table.concat {cmd, " ", get_object_file(v)}
    end

    -- tell the user what's going on
    if show_commands then
        print(cmd)
    else
        print(table.concat {"Linking ", configs[chosen_config].output})
    end

    -- do the linking stage
    os.execute(cmd)
end
