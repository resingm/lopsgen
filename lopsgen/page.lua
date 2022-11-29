require "utils"

Page = {}

function Page:new(filename, content)
    local t = setmetatable({}, { __index = Page })

    t.fname = filename
    t.content = content

    t.title = nil
    t.subtitle = nil
    t.date = nil
    t.header_title = nil
    t.header_subtitle = nil
    t.header_short = nil
    t.body = nil

    return t
end

function Page:load_and_parse_page()
    local lines = utils.read_text_file_lines(self.fname)

    local title = ""
    local subtitle = ""
    local date = ""
    local header_title = ""
    local header_subtitle = ""
    local header_short = ""
    local body = ""

    local is_header = false

    for i, l in ipairs(lines) do

        -- 
        -- if string.find{s=l, pattern="{::header}", plain=true} then is_header = true end
        -- if string.find{s=l, pattern="{:/header}"}, plain=true} then is_header = false end

        -- define is_header to ensure header is parsed properly
        if string.find(l, "{::header}") then is_header = true end
        if string.find(l, "{:/header}") then is_header = false end

        -- if string.find(l, "<!--", plain=true) then
            -- parse meta data (title, subtitle, date, ...)
        -- elseif string.find(l, "{::header}", plain=true) then
            -- parse header data
        -- end

        if string.find(l, "<!--%s*.+:.+%s-->") then
            -- Parse the meta information in there
        else
            -- Add line to a regular body
        end
    end
    
end
