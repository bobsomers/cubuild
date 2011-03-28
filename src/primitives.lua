-- blueprint "primitives"

function check_inside_config()
    if current_config == "" then
        kaboom("Your blueprint has a config option outside of a config.")
    end
end

-- set the gpu sdk path (used to automatically include gpu sdk headers)
function gpu_sdk_path(path)
    sdk_path = path
end

-- set the default config name
function default(name)
    default_config = name
end

-- set the current config (and creates a fresh table if it doesn't exist yet)
function config(name)
    if string.sub(name, 1, 1) == "-" then
        kaboom("Config name '" .. name .. "' can't start with a dash.")
    end

    if name == "default" then
        kaboom("You can't name a config 'default'.")
    end

    if configs[name] == nil then
        configs[name] = {
            output = "a.out",
            debugging = false,
            profiling = false,
            optimizing = false,
            defines = {},
            includes = {},
            cflags = {},
            libdirs = {},
            libs = {},
            lflags = {}
        }
    end

    current_config = name
end

-- set the output name
function output(name)
    check_inside_config()
    configs[current_config].output = name
end

-- turn debugging options on
function debugging(debug)
    if debug == "on" then
        configs[current_config].debugging = true
    else
        configs[current_config].debugging = false
    end
end

-- turn profiling options on
function profiling(profile)
    if profile == "on" then
        configs[current_config].profiling = true
    else
        configs[current_config].profiling = false
    end
end

-- turn optimizing options on
function optimizing(optimize)
    if optimize == "on" then
        configs[current_config].optimizing = true
    else
        configs[current_config].optimizing = false
    end
end

-- add defines to the list of compiler defines
function defines(defs)
    for _, v in ipairs(defs) do
        table.insert(configs[current_config].defines, v)
    end
end

-- add directories to the list of include search directories
function includes(incs)
    for _, v in ipairs(incs) do
        table.insert(configs[current_config].includes, v)
    end
end

-- add compiler flags to the list of compiler flags
function cflags(flags)
    for _, v in ipairs(flags) do
        table.insert(configs[current_config].cflags, v)
    end
end

-- add directories to the list of library search directories
function libdirs(dirs)
    for _, v in ipairs(dirs) do
        table.insert(configs[current_config].libdirs, v)
    end
end

-- add libraries to the list of linked libraries
function libs(ls)
    for _, v in ipairs(ls) do
        table.insert(configs[current_config].libs, v)
    end
end

-- add linker flags to the list of linker flags
function lflags(flags)
    for _, v in ipairs(flags) do
        table.insert(configs[current_config].lflags, v)
    end
end
