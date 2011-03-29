-- constants (well, actually just variables you should not write to...)
VERSION = "0.1"

-- global state
sdk_path = ""
configs = {}
current_config = ""
default_config = ""
chosen_config = "default"
show_commands = false

-- exit with an error
function kaboom(msg)
    io.stderr:write(msg .. "\n")
    os.exit(1)
end
