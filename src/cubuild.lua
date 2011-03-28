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

print("Starting build of '" .. chosen_config .. "'.")








-- dump out everything
--[[
print("SDK Path: " .. sdk_path)
print("Default Config: " .. default_config)
for k, v in pairs(configs) do
    print("Config: " .. k)
    print("\tOutput: " .. v.output)
    if v.debugging then print("\tDebugging: On") else print("\tDebugging: Off") end
    if v.profiling then print("\tProfiling: On") else print("\tProfiling: Off") end
    if v.optimizing then print("\tOptimizing: On") else print("\tOptimizing: Off") end
    
    print("\tDefines:")
    for _, val in ipairs(v.defines) do
        print("\t\t" .. val)
    end
    
    print("\tIncludes:")
    for _, val in ipairs(v.includes) do
        print("\t\t" .. val)
    end
    
    print("\tCompile Flags:")
    for _, val in ipairs(v.cflags) do
        print("\t\t" .. val)
    end
    
    print("\tLib Dirs:")
    for _, val in ipairs(v.libdirs) do
        print("\t\t" .. val)
    end
    
    print("\tLibs:")
    for _, val in ipairs(v.libs) do
        print("\t\t" .. val)
    end
    
    print("\tLink Flags:")
    for _, val in ipairs(v.lflags) do
        print("\t\t" .. val)
    end
end
--]]

-- all done
print("Done.")
