
function ReadTextFile (fname)
    local f, err = assert(io.open(fname, "r"))
    
    if err then return nil, err end

    local payload = f:read("a")
    f:close()

    return payload
end

function ReadTextFileLines (fname)
    local f, err = assert(io.open(fname, "r"))
    local payload = {}

    if err then return nil, err end

    for l in f:lines() do
        table.insert(payload, l)
    end

    f:close()
    return payload
end


function ScanDir(dirname)
    -- local i, t, popen = 0, {}, io.popen
    local i, files = 0, {}
    local pfile, err = io.popen('ls -a ' .. dirname .. '/*.md')
    pfile = pfile or {}

    if err then return nil, err end

    for fname in pfile:lines() do
        i = i + 1
        files[i] = fname
    end

    pfile:close()

    return files
end

function Write (fname, payload)
    local f, err = assert(io.open(fname, "w"))
    if err then return err end

    f:write(payload)
    f:close()
end
