-- handles the compilation phase

function compile(files)
    for _, v in ipairs(files) do
        local cmd = "nvcc"

        -- compile to object file
        cmd = table.concat {cmd, " -c"}

        -- debugging?
        if configs[chosen_config].debugging then
            cmd = table.concat {cmd, " -g -G"}
        end
        
        -- profiling?
        if configs[chosen_config].profiling then
            cmd = table.concat {cmd, " -pg"}
        end
        
        -- optimizing?
        if configs[chosen_config].optimizing then
            cmd = table.concat {cmd, " -O3"}
        end
        
        -- force verbose information from the CUDA compiler for register
        -- and shared memory usage info
        cmd = table.concat {cmd, " -Xptxas -v"}
        
        -- set the virtual architecture and specific architecture that we're
        -- compiling for
        if configs[chosen_config].compute_capability == "1.0" then
            cmd = table.concat {cmd, " -arch=compute_10 -code=sm_10"}
        elseif configs[chosen_config].compute_capability == "1.1" then
            cmd = table.concat {cmd, " -arch=compute_11 -code=sm_11"}
        elseif configs[chosen_config].compute_capability == "1.2" then
            cmd = table.concat {cmd, " -arch=compute_12 -code=sm_12"}
        elseif configs[chosen_config].compute_capability == "1.3" then
            cmd = table.concat {cmd, " -arch=compute_13 -code=sm_13"}
        elseif configs[chosen_config].compute_capability == "2.0" then
            cmd = table.concat {cmd, " -arch=compute_20 -code=sm_20"}
        end

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
