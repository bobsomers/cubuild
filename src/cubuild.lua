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

-- compile the files
compile(files)

-- link the files
link(files)

-- all done
print("Done.")
