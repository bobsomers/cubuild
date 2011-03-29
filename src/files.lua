-- functions for finding and manipulating source files

function get_source_files(path)
    local found = {}

    for file in lfs.dir(path) do
        local f = path .. "/" .. file
        if file ~= "." and file ~= ".." then
            local attr = lfs.attributes(f)
            assert(type(attr) == "table")
            if attr.mode == "directory" then
                for _, v in ipairs(get_source_files(f)) do
                    table.insert(found, v)
                end
            elseif attr.mode == "file" then
                local last2 = string.sub(f, -2)
                local last3 = string.sub(f, -3)
                local last4 = string.sub(f, -4)
                
                if last2 == ".c" or
                   last3 == ".cc" or
                   last3 == ".cu" or
                   last4 == ".cpp" or
                   last4 == ".cxx" then
                    table.insert(found, f)
                end
            end
        end
    end

    return found
end

function get_object_file(src_file)
    local dot = string.find(src_file, ".", -4, true)
    return string.sub(src_file, 1, dot) .. "o"
end

function get_relative_path(file)
    return string.sub(file, string.len(lfs.currentdir()) + 2)
end
