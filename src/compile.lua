-- handles the compilation phase

function compile(files)
    for _, v in ipairs(files) do
        local cmd = "nvcc"

        -- compile to object file
        cmd = table.concat {cmd, " -c"}

        -- defines
        for _, val in ipairs(configs[chosen_config].defines) do
            cmd = table.concat {cmd, " -D", val}
        end

        -- gpu computing sdk include
        cmd = table.concat {cmd, " -I", sdk_path, "/C/common/inc"}

        -- other includes
        for _, val in ipairs(configs[chosen_config].includes) do
            cmd = table.concat {cmd, " -I", val}
        end

        -- compiler flags
        for _, val in ipairs(configs[chosen_config].cflags) do
            cmd = table.concat {cmd, " -Xcompiler ", val}
        end

        -- output file name
        cmd = table.concat {cmd, " -o ", get_object_file(v)}

        -- input source file
        cmd = table.concat {cmd, " ", v}

        -- tell the user what we're doing
        if show_commands then
            print(cmd)
        else
            print(table.concat {"Compiling ",  get_relative_path(v)})
        end

        -- do the compilation
        os.execute(cmd)
    end
end
