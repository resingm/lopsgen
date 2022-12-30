require "lopsgen/utils"

LineType = {
    META = 1,
    HEADER = 2,
    BODY = 3,
}

Page = {}

function Page:new(o)
    -- local t = setmetatable({}, { __index = Page })
    local o = o or {}
    setmetatable(o, self)

    o.header = {}
    o.body = {}
    o.properties = {}

    o.path = Page.generate_paths(o.fname)

    self.__index = self
    return o
end

function Page.generate_paths(src)
    local path = {}

    local obj = string.match(src, Conf.pages .. "/(%g+)%.md")
    local obj_path = string.match(obj, "^(%g*)/.+$")

    path.obj = obj
    path.obj_path = obj_path or ""
    path.input = Conf.pages .. "/" .. obj .. ".md"
    path.output = Conf.output .. "/" .. obj .. ".html"
    path.uri = Conf.base_path .. "/" .. obj .. ".html"

    return path
end

function Page:load_and_parse_page()
    local lines = ReadTextFileLines(self.path.input)
    local is_header = false

    for i, l in ipairs(lines or {}) do
        -- define is_header to ensure header is parsed properly
        local line_type = LineType.BODY;

        if string.find(l, "{::header}") then
            is_header = true
            l = string.gsub(l, '{::header}', '')
        end
        if string.find(l, "{:/header}") then
            is_header = false
            l = string.gsub(l, '{:/header}', '')
        end

        local line_type = LineType.BODY
        
        if string.find(l, "<!--.+-->") then
            line_type = LineType.META
        elseif is_header then
            line_type = LineType.HEADER
        else
            line_type = LineType.BODY
        end

        if line_type == LineType.META then
            -- TODO: Fails to read with underscore. Check whats going wrong
            local p = "<!%-%-%s*([%w%_]+)%s*:%s*(.+)%s*%-%->"

            for k, v in string.gmatch(l, p) do
                -- TODO: Strip leading and trailing whitespaces.
                k = string.strip(k)
                v = string.strip(v)
                self.properties[k] = v
            end
        elseif line_type == LineType.HEADER then
            table.insert(self.header, l)
        elseif line_type == LineType.BODY then
            table.insert(self.body, l)
        end
    end
end
