-- load the blueprint
local blueprint = loadfile(lfs.currentdir() .. "/blueprint.lua")
if blueprint == nil then
    kaboom("Couldn't locate blueprint.lua in the current directory.")
end
blueprint()

-- handle command line options
for i, v in ipairs(arg) do
    if string.sub(v, 1, 1) == "-" then
        handle_cmd_arg(string.sub(v, 2))
    else
        if chosen_config ~= "default" then
            kaboom("Usage: cubuild [options] [config]")
        end
        chosen_config = v
    end
end

-- if the chosen config was "default", then make sure they have a default defined
if chosen_config == "default" then
    if default_config == "" then
        kaboom("No default config defined in your blueprint!")
    end
    chosen_config = default_config
end

-- check that the chosen config exists
if configs[chosen_config] == nil then
    kaboom("Config '" .. chosen_config .. "' is not defined in your blueprint!")
end

print("Starting build: " .. chosen_config)

-- descend into all subdirectories to get the list of source files
local files = get_source_files(lfs.currentdir())

-- compile all the files
for _, v in ipairs(files) do
    local cmd = "nvcc"

    -- compile to object file
    cmd = table.concat {cmd, " -c"}

    -- defines
    for _, val in ipairs(configs[chosen_config].defines) do
        cmd = table.concat {cmd, " -D", val}
    end

    -- gpu computing sdk include
    cmd = table.concat {cmd, " -I", sdk_path, "/C/common/inc"}

    -- other includes
    for _, val in ipairs(configs[chosen_config].includes) do
        cmd = table.concat {cmd, " -I", val}
    end

    -- compiler flags
    for _, val in ipairs(configs[chosen_config].cflags) do
        cmd = table.concat {cmd, " -Xcompiler ", val}
    end

    -- output file name
    cmd = table.concat {cmd, " -o ", get_object_file(v)}

    -- input source file
    cmd = table.concat {cmd, " ", v}

    -- tell the user what we're doing
    if show_commands then
        print(cmd)
    else
        print(table.concat {"Compiling ",  get_relative_path(v)})
    end

    -- do the compilation
    os.execute(cmd)
end

-- linking stage
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

-- all done
print("Done.")
