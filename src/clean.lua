-- handles the clean phase

function clean(files)
    if show_commands == false then
        print("Removing object files")
    end
    for _, v in ipairs(files) do
        local cmd = table.concat {"rm -f ", get_object_file(v)}
        if show_commands then
            print(cmd)
        end
        os.execute(cmd)
    end
    
    if show_commands == false then
        print("Removing output binaries")
    end
    for k, v in pairs(configs) do
        local cmd = table.concat {"rm -f ", v.output}
        if show_commands then
            print(cmd)
        end
        os.execute(cmd)
    end
end
