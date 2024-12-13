local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event
local nui_contents_file = require("nui_cheatsheet.nui_table_control")

local M = {}

function M.toggle_menu()
    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
        },
        position = "50%",
        size = {
            width = "80%",
            height = "60%",
        },
    })

    -- mount/open the component
    popup:mount()

    local ok = popup:map("n", "q", function(bufnr)
        print("Leaving cheatsheet")
        popup:unmount()
    end, { noremap = true })

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)

    -- set content
    local contents = nui_contents_file.display_table()
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, contents)
end

M.toggle_menu()
