
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
