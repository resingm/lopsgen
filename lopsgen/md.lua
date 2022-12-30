
Markdown = {}

function Markdown.generate_short_description(p)
    local date = "*" .. p.properties.date .. "* "
    local title = "**[" .. string.strip(p.properties.header_title) .. "](" .. p.path.uri .. ")**\n"
    local desc = string.strip(table.concat(p.header, "\n"))
    return date .. title .. "\n" .. desc .. "\n"
end

function Markdown.generate_title(p)
    local date = "*" .. p.properties.date .. "* "
    local title = "[" .. string.strip(p.properties.header_title) .. "](" .. p.path.uri .. ")\n"
    return date .. title .. "\n"
end

function Markdown.to_html(md)
    local tmp_in, tmp_out = os.tmpname(), os.tmpname()

    Write(tmp_in, md)
    Run("python -m markdown " .. tmp_in .. " > " .. tmp_out, false)
    local html = ReadTextFile(tmp_out)

    os.remove(tmp_in)
    os.remove(tmp_out)

    return html
end
