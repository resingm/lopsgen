require "lopsgen/page"
require "lopsgen/utils"


local function render_template(template, page, markdown)
    local pattern = "{{%s*([%w%.%_%-]+)%s*}}"
    local html = ""

    for i, l in ipairs(template) do
        -- for w in string.gmatch(l, "{{%s*([%w%.%_%-]+)%s*}}") do
        for prop in string.gmatch(l, pattern) do
            local p = "{{%s*" .. prop .. "%s*}}"
            -- TODO: Add markdown rendering
            local r = (prop == "markdown" and "!! TODO !!") or page.properties[prop] or ""
            l = string.gsub(l, p, tostring(r))
        end
        
        html = html .. l .. "\n"
    end

    return html
end

local function render_page(base_template, header_template, page)
    -- Render the header if required
    local header_html = #page.header > 0 and render_template(header_template, page) or ""
    page.header = header_html

    -- TODO: render markdown
    local markdown = "<p>this is some HTML rendered based on a markdown generator</p>"

    page.markdown = markdown
    page.current_year = os.date("%Y")
    
    return render_template(base_template, page)
end


function Main()

    -- load config
    -- TODO: Load config from file
    local cfg = {
        input = "./content",
        static = "./static",
        output = "./site",
        template = {
            base = "./layout/base.html",
            header = "./layout/header.html",
        },
    }

    -- load templates
    local tmp_base, err = ReadTextFileLines(cfg.template.base)
    local tmp_header, err = ReadTextFileLines(cfg.template.header)

    -- Delete output directory if existing
    os.execute('rm -rd "' .. cfg.output .. '"')
    os.execute('mkdir "' .. cfg.output .. '"')

    -- Copy static data into new output directory
    os.execute('cp -r "' .. cfg.static .. '" "' .. cfg.output .. '"')

    for _, p in ipairs(ScanDir(cfg.input) or {}) do
        -- print(i .. " - " .. p)
        local page = Page:new{fname = p}
        page:load_and_parse_page()

        -- Render the HTML of the site
        local html = render_page(tmp_base, tmp_header, page)

        -- Build the output filename
        local fname = string.match(p, ".*/([^/]+)") 
        fname = cfg.output .. '/' .. fname

        Write(fname, html)
    end
end

Main()
