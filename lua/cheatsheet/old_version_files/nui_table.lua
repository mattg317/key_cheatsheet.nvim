local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local contents_file = require("cheatsheet.table_control")
local M = {}

NUI_bufnr_id = nil
NUI_win_id = nil

local function create_popup()
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

    popup:mount()

    return {
        popup = popup,
        bufnr = popup.bufnr,
        nui_win_id = popup.winid
    }
end

function M.toggle_popup(open)

    if open == true
        then
            popup:mount()
    else
        popup:unmount()
    end

end
local function close_menu(popup_menu)
    popup_menu.popup:unmount()
end

-- toggle popup
-- if open then mount
-- else unmount


-- set content
-- vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { "Hello World" })

function M.toggle_menu()

    local popup_menu = create_popup()
    local table_contents = contents_file.display_table()


    vim.api.nvim_buf_set_lines(popup_menu.bufnr, 0, 1, false, table_contents)

    -- unmount component when cursor leaves buffer
    popup_menu.popup:on(event.BufLeave, function()
        popup_menu.popup:unmount()
    end)

end

M.toggle_menu()

return M
