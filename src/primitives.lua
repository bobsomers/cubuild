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

    if name == "clean" then
        kaboom("You can't name a config 'clean'.")
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
            lflags = {},
            compute_capability = "1.0",
            max_registers = ""
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
    check_inside_config()
    if debug == "on" then
        configs[current_config].debugging = true
    else
        configs[current_config].debugging = false
    end
end

-- turn profiling options on
function profiling(profile)
    check_inside_config()
    if profile == "on" then
        configs[current_config].profiling = true
    else
        configs[current_config].profiling = false
    end
end

-- turn optimizing options on
function optimizing(optimize)
    check_inside_config()
    if optimize == "on" then
        configs[current_config].optimizing = true
    else
        configs[current_config].optimizing = false
    end
end

-- add defines to the list of compiler defines
function defines(defs)
    check_inside_config()
    for _, v in ipairs(defs) do
        table.insert(configs[current_config].defines, v)
    end
end

-- add directories to the list of include search directories
function includes(incs)
    check_inside_config()
    for _, v in ipairs(incs) do
        table.insert(configs[current_config].includes, v)
    end
end

-- add compiler flags to the list of compiler flags
function cflags(flags)
    check_inside_config()
    for _, v in ipairs(flags) do
        table.insert(configs[current_config].cflags, v)
    end
end

-- add directories to the list of library search directories
function libdirs(dirs)
    check_inside_config()
    for _, v in ipairs(dirs) do
        table.insert(configs[current_config].libdirs, v)
    end
end

-- add libraries to the list of linked libraries
function libs(ls)
    check_inside_config()
    for _, v in ipairs(ls) do
        table.insert(configs[current_config].libs, v)
    end
end

-- add linker flags to the list of linker flags
function lflags(flags)
    check_inside_config()
    for _, v in ipairs(flags) do
        table.insert(configs[current_config].lflags, v)
    end
end

-- set compute capability to compile for
function compute_capability(cap)
    check_inside_config()    
    if cap == "1.0" or cap == "1.1" or cap == "1.2" or cap == "1.3" or cap == "2.0" then
        configs[current_config].compute_capability = cap
    else
        kaboom("Unknown compute capability in config " .. current_config .. ", expected 1.0, 1.1, 1.2, 1.3, or 2.0.")
    end
end

-- set max register usage for CUDA kernels
function max_registers(regs)
    check_inside_config()
    configs[current_config].max_registers = regs
end
