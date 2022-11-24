
function read_text_file (fname)
    f, err = assert(io.open(fname, "r"))
    
    if err then return nil, err end

    payload = f:read("a")
    f:close()

    return payload
end


function scan_dir(dirname)
    -- local i, t, popen = 0, {}, io.popen
    local i, files = 0, {}
    local pfile, err = io.popen('ls -a ' .. dirname .. '/*.md')

    if err then return nil, err end

    for fname in pfile:lines() do
        i = i + 1
        files[i] = fname
    end

    pfile:close()

    return files
end
