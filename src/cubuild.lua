-- create live and build loggers
local livelog = logging.console("[%level] %message\n")
local buildlog = logging.file("cubuild.log")

-- load the blueprint and parse it
local fh = io.open(lfs.currentdir() .. "/blueprint")
if fh == nil then
    livelog:fatal("Couldn't open your blueprint file. Does it exist?")
    return
end
local blueprint = json.decode(fh:read("*a"))
fh:close()

-- warn if the user hasn't made a default config
if not blueprint.default then
    livelog:warn("You don't have a default build config defined.")
end

-- figure out which build configuration we want to build
local config = ""
if #arg == 0 then
    -- hopefully we have a default config defined
    if not blueprint.default then
        livelog:fatal("What do you want me to build? If you don't define a default config, you need to tell me on the command line.")
        return
    end
    config = blueprint.default
elseif #arg == 1 then
    -- if the user thinks they're clever, they might ask us to build the default explicity
    if arg[1] == "default" then
        if not blueprint.default then
            livelog:fatal("Well aren't you clever, you asked me to build the default config explicitly, but you didn't define one in your blueprint!")
            return
        end
        config = blueprint.default
    else
        config = arg[1]
    end
else
    livelog:fatal("Whoa there tiger, that's more arguments than I know what to do with. I only take one argument, and it's the build config you want to run.")
    return
end

-- verify that the config is actually defined
if not blueprint[config] then
    livelog:fatal("Config '" .. config .. "' is not defined in your blueprint!")
    return
end

livelog:info("You asked me to build config '" .. config .. "'")
livelog:info("Done.")
