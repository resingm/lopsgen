require "page"
require "utils"

function main()

    -- load config
    -- TODO: Load config from file
    cfg = {
        input = "./content",
        static = "./static",
        output = "./site",
        template = {
            base = "./layout/base.html",
            header = "./layout/header.html",
        },
    }

    -- load templates
    tmp_base, err = read_text_file(cfg.template.base)
    tmp_header, err = read_text_file(cfg.template.header)
    -- TODO: Implement error handling

    -- load filenames of pages
    pages = scan_dir(cfg.input)

    for i, p in ipairs(pages) do
        print(i .. " - " .. p)
    end


end

main()
