-- handles command line arguments

function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function handle_cmd_arg(arg)
    if arg == "version" or arg == "v" then
        print("cubuild v" .. VERSION .. " (Beerware License)")
        print("Built by " .. trim(BUILD_MACHINE) .. "/" .. trim(BUILD_ARCH) .. " on " .. trim(BUILD_DATE))
        print("from Git commit " .. trim(GIT_COMMIT))
        print("Bob Somers 2011 -- http://github.com/bobsomers/cubuild")
        print("")
        if os.execute("nvcc --version") ~= 0 then
            kaboom("Problem when trying invoke nvcc... is your PATH set up correctly?")
        end
        print("")
        if os.execute("gcc --version") ~= 0 then
            kaboom("Problem when trying invoke gcc... is your PATH set up correctly?")
        end
        if os.execute("g++ --version") ~= 0 then
            kaboom("Problem when trying invoke g++... is your PATH set up correctly?")
        end
        os.exit(0)
    else
        kaboom("Unknown option -" .. arg)
    end
end
