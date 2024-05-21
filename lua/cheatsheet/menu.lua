local popup = require("plenary.popup")
local contents_file = require("cheatsheet.table_control")
local nui_contents_file = require("cheatsheet.nui_table_control")


local M = {}
local api = vim.api

CS_cmd_win_id = nil
CS_cmd_bufh = nil

local function close_menu()
    vim.api.nvim_win_close(CS_cmd_win_id, true)
    CS_cmd_win_id = nil
end

local function create_window()
    local width = 50
    local height = 10
    local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
    local bufnr = api.nvim_create_buf(false, false)

    local CS_cmd_win_id, win = popup.create(bufnr, {
        title = "Shortcuts",
        line = math.floor(((vim.o.lines - height) / 2) - 1),
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = borderchars
    })


    return {
        bufnr = bufnr,
        win_id = CS_cmd_win_id
    }
end


function M.toggle_menu()
    if
        CS_cmd_win_id ~= nil
        and api.nvim_win_is_valid(CS_cmd_win_id)
    then
        close_menu()
        return
    end

    local win_info = create_window()
    -- local contents = contents_file.display_table()
    local contents = nui_contents_file.display_table()


    CS_cmd_win_id = win_info.win_id
    CS_cmd_bufh = win_info.bufnr

    api.nvim_buf_set_lines(CS_cmd_bufh, 0, #contents, false, contents)
    api.nvim_buf_set_option(CS_cmd_bufh, "buftype", "acwrite")
    api.nvim_buf_set_option(CS_cmd_bufh, "bufhidden", "delete")
    api.nvim_buf_set_keymap(
            CS_cmd_bufh,
            "n",
            "q",
            "<Cmd>lua require('cheatsheet.menu').toggle_menu()<CR>",
            { silent = true }
        )

    --     For debugging purposes use these key binds when calling function inside here
    -- api.nvim_buf_set_keymap(
    --     CS_cmd_bufh,
    --     "n",
    --     "q",
    --     ":close<CR>",
    --     { silent = false }
    --     )

    vim.cmd(
        string.format(
            "autocmd BufModifiedSet <buffer=%s> set nomodified",
            CS_cmd_bufh
            )
        )
    vim.cmd(
        "autocmd BufLeave <buffer> ++nested ++once silent close"

    )

end

return M

