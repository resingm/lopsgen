#!/usr/bin/env lua

require "lopsgen/md"
require "lopsgen/page"
require "lopsgen/utils"


-- load config
-- TODO: Load config from file
Conf = {
    base_path = "https://www.maxresing.de",
    -- base_path = "file:///home/max/workspace/de/maxresing/lopsgen/site",
    pages = "./content",
    static = "./static",
    output = "./site",
    template = {
        base = "./layout/base.html",
        header = "./layout/header.html",
    },
}

local function blog_selection (pages, n)
    local selection = {}

    for obj, _ in pairs(pages) do 
        if string.match(obj, "%d+-?.*") then
            table.insert(selection, obj)
        end
    end

    table.sort(selection)

    local i = (#selection < n and 1) or (#selection - n + 1)

    return table.reverse { table.unpack(selection, i) }
end

local function render_template(template, properties)
    local pattern = "{{%s*([%w%.%_%-]+)%s*}}"
    local html = ""

    for i, l in ipairs(template) do
        for prop in string.gmatch(l, pattern) do
            local p = "{{%s*" .. prop .. "%s*}}"
            local r = (prop == "markdown") and Markdown.to_html(properties[prop]) or properties[prop]
            r = (type(r) == "string" and string.gsub(r, "%%", "%%%%")) or ""

            l = string.gsub(l, p, tostring(r))
        end
        
        html = html .. l .. "\n"
    end

    return html
end

local function render_page(base_template, header_template, page)
    -- Render the header if required
    page.properties.markdown = page.header
    local header_html = #page.header > 0 and render_template(header_template, page.properties) or ""
    page.properties.header = header_html

    page.properties.markdown = page.body
    page.properties.current_year = os.date("%Y")
    
    return render_template(base_template, page.properties)
end


local function main()

    -- load templates
    local tmp_base, err = ReadTextFileLines(Conf.template.base)
    local tmp_header, err = ReadTextFileLines(Conf.template.header)

    -- local blog, err = generate_blog_struct(Conf.pages .. "/blog")

    -- Delete output directory if existing
    os.execute('rm -rd "' .. Conf.output .. '"')
    os.execute('mkdir "' .. Conf.output .. '"')

    -- Copy static data into new output directory
    os.execute('cp -r "' .. Conf.static .. '"/* "' .. Conf.output .. '"')

    local source_files = ScanDir(Conf.pages) or {}

    -- find blog pages which are used for announcements
    local pages = {}

    for _, f in ipairs(source_files) do
        local p = Page:new{fname = f}
        p:load_and_parse_page()

        pages[p.path.obj] = p
    end

    for obj, p in pairs(pages) do
        if obj == "index" then
            goto continue
        end

        -- Render the HTML of the site
        local html = render_page(tmp_base, tmp_header, p)

        -- Build the output filename
        -- local fname = string.gsub(p, Conf.pages, Conf.output)
        -- fname = string.gsub(fname, "%.md", ".html")
        -- dirname = string.match(fname, ".*/")
        -- fname = Conf.output .. '/' .. fname
        os.execute("mkdir -p " .. Conf.output .. "/" .. p.path.obj_path)
        Write(p.path.output, html)

        ::continue::
    end

    -- Now build the index page with the announcements
    local blog_md = {}
    table.insert(blog_md, "***\n")

    for i, obj in ipairs(blog_selection(pages, table.len(pages))) do
        print("Appending " .. obj .. " to blog post section")

        if i < 4 then
            table.insert(blog_md, Markdown.generate_short_description(pages[obj]))
            table.insert(blog_md, "\n***\n")

            -- TODO: Generate the first n blog entries with description
            -- local desc = table.concat(pages[obj].header, "\n")

            -- table.insert(blog_md, "***\n")
            -- table.insert(blog_md, "**" .. string.strip(pages[obj].properties.header_title) .. "**\n")
            -- table.insert(blog_md, "\n*" .. pages[obj].properties.date .. "* " .. string.strip(desc) .. "\n")
        else
            -- TODO: Generate the last n blog entries with just a title
            -- table.insert(blog_md, "\n*" .. pages[obj].properties.date .. "* " .. string.strip(pages[obj].properties.header_title) .. "\n")
            table.insert(blog_md, Markdown.generate_title(pages[obj]))
        end
    end

    -- TODO: Implement blog/index page.

    for _, l in ipairs(blog_md) do
        table.insert(pages["index"].body, l)
    end

    local index_html = render_page(tmp_base, tmp_header, pages["index"])
    Write(pages["index"].path.output, index_html)
end

main()
