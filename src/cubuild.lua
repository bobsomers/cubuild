-- read in the blueprint file and parse it
fh = assert(io.open(lfs.currentdir() .. "/blueprint"))
blueprint = json.parse(fh:read("*a"))
fh:close()

-- figure out which build configuration we want to build
if #args == 0 then
    -- hopefully we have a default config defined
    if not blueprint.default then
        error("What do you want me to build? No build configuration was specified on the command line and your blueprint doesn't have a default defined!")
    end
    config = blueprint.default
elseif #args == 1 then
    -- if the user thinks they're clever, they might ask us to build the default explicity
    if args[1] == "default" then
        if not blueprint.default then
            error("Well aren't you clever, you asked me to build the default config, but you didn't define one in your blueprint!")
        end
        config = blueprint.default
    else
        config = args[1]
    end
else
    error("Whoa there tiger, that's more arguments than I know what to do with. I only take one argument, and it's the build config you want to run.")
end

-- verify that the config is actually defined
if not blueprint[config] then
    error("Config '" .. config .. "' is not defined in your blueprint!")
end

print("You asked me to build config '" .. config .. "'")

print("Done.")
