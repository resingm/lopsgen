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

    self.__index = self
    return o
end

function Page:load_and_parse_page()
    local lines = ReadTextFileLines(self.fname)
    local is_header = false

    for i, l in ipairs(lines or {}) do
        -- define is_header to ensure header is parsed properly
        local line_type = LineType.BODY;

        if string.find(l, "{::header}") then is_header = true end
        if string.find(l, "{:/header}") then is_header = false end

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
            local p = "<!%-%-%s*([%w_]+)%s*:%s*(%g+)%s*%-%->"

            for k, v in string.gmatch(l, p) do
                self.properties[k] = v
            end
        elseif line_type == LineType.HEADER then
            table.insert(self.header, l)
        elseif line_type == LineType.BODY then
            table.insert(self.body, l)
        end
    end
end
