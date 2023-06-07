local popup = require("plenary.popup")
local M = {}
local api = vim.api

local function create_window()
    local width = 50
    local height = 10
    local bufnr = api.nvim_create_buf(false,false)
    local CS_win_id, win = popup.create(bufnr, {
        title = "Test",
        minwidth = width,
        minheight = height
    })


    return {
        bufnr = bufnr,
        win_id = CS_win_id
    }
end

function M.toggle_menu()
    local win_info = create_window()
    local contents = {
        "<CR> - Select auto suggestions",
        "%s/foo/bar/g - Find and replace all",
    }

    CS_win_id = win_info.win_id
    CS_bufh = win_info.bufnr

    api.nvim_buf_set_lines(CS_bufh, 0, #contents, false, contents)
    api.nvim_buf_set_keymap(CS_bufh, "n", "q", ":close<CR>", { silent = true })
    -- api.nvim_buf_set_option(CS_bufh, "bufhidden", "delete")
    vim.cmd(
        string.format(
            "autocmd BufModifiedSet <buffer=%s> set nomodified",
            CS_bufh
            )
        )
    vim.cmd(
        "autocmd BufLeave <buffer> ++nested ++once silent close"

    )

end

M.toggle_menu()

return M
