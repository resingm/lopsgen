
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
    -- local pfile, err = io.popen('ls -ADR ' .. dirname .. '/*.md')
    local pfile, err = io.popen("find " .. dirname .. " -type f -name '*.md'")
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
    payload = type(payload) == "table" and table.concat(payload, '\n') or payload

    local f, err = assert(io.open(fname, "w"))
    if err then return err end

    f:write(payload)
    f:close()
end

function Run(cmd, raw)
    local f, err = assert(io.popen(cmd, 'r'))
    if err then return err end

    local s, err = assert(f:read('*a'))
    if err then return err end

    f:close()

    if raw then return s end

    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    return s
end

---Revereses an index based table
---
---@param t table
---@return table
function table.reverse(t)
    local l = #t + 1

    for i = 1, math.floor(#t / 2) do
        t[i], t[l - i] = t[l - i], t[i]
    end

    return t
end

function table.len(t)
    local c = 0
    for _ in pairs(t) do c = c + 1 end
    return c
end

function string.strip(s)
    return string.match(s, "^%s*(.-)%s*$")
end
