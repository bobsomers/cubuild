-- handles the linking phase

function link(files)
    local cmd = "nvcc"

    -- library directories
    for _, val in ipairs(configs[chosen_config].libdirs) do
        cmd = table.concat {cmd, " -L", val}
    end

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
