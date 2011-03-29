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
if configs[chosen_config] == nil and chosen_config ~= "clean" then
    kaboom("Config '" .. chosen_config .. "' is not defined in your blueprint!")
end

-- either build or clean, based on the chosen config
local files = get_source_files(lfs.currentdir())
if chosen_config == "clean" then
    print("Starting clean")
    clean(files)
else
    print("Starting build: " .. chosen_config)
    compile(files)
    link(files)
end

-- all done
print("Done.")
