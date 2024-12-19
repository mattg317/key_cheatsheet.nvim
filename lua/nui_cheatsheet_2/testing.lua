-- local contents = vim.fn.stdpath('data') .. "/cheat_test_delete/"

-- if vim.fn.isdirectory(contents) == 1 then
--     print("Exists")
--     local file, err = io.open(contents .. "/delete_me.txt", "w")
--     if file == nil then
--         print("Couldn't open file: " .. err)
--     else
--         file:write("Your first command")
--         file:close()
--     end
-- else
--     print("Doesn't exist creating" .. contents)
--     vim.fn.mkdir(contents)
-- end

-- checking if file exist
-- function file_exists(name)
--    local f=io.open(name,"r")
--    if f~=nil then io.close(f) return true else return false end
-- end


-- print(vim.fn.isdirectory(contents))
local table_command = require("nui_cheatsheet_2.table_commands")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event

local table_menu = function()
    local tm = table_command.read_table()
    local test_table = {}
    for index, value in ipairs(tm) do
        local data = { id = index }
        table.insert(test_table, Menu.item(value, data))
    end
    return test_table
end


local menu = Menu({
    position = "50%",
    size = {
        width = "40%",
        height = "40%",
    },
    border = {
        style = "single",
        text = {
            top = "Select a note to delete",
            top_align = "center",
        },
    },
    win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
    },
}, {
    lines = table_menu(),
    max_width = 20,
    keymap = {
        focus_next = { "j", "<Down>", "<Tab>" },
        focus_prev = { "k", "<Up>", "<S-Tab>" },
        close = { "<Esc>", "<C-c>" },
        submit = { "<CR>", "<Space>" },
    },
    on_close = function()
        print("Menu Closed!")
    end,
    on_submit = function(item)
        local confirm_delete = vim.fn.input("Are you sure you want to delete note "
            .. item.text .. "? - y/n ")
        print("Menu Submitted: ", item.text)
        print("Menu id: ", item._id)
        if confirm_delete == 'y'
        then
            vim.cmd('redraw')
        table_command.delete_from_table(item._id)
        else
            vim.cmd('redraw')
            print("Not deleting " .. item.text)
        end
    end,
})

-- mount the component
menu:mount()
local ok = menu:map("n", "q", function(bufnr)
    menu:unmount()
end, { noremap = true })
