local Input = require("nui.input")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local contents =
-- "/Users/mgiordanella/Main/30-39_Coding/30_Nvim/nvim_custom_plugins/key_cheatsheet.nvim/lua/cheatsheet/files/sample.csv"
"/Users/mgiordanella/Main/30-39_Coding/30_Nvim/nvim_custom_plugins/key_cheatsheet.nvim/lua/cheatsheet/files/test.csv"

local M = {}

function M.read_table()
    local table_c = {}
    local file, err = io.open(contents, "r")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for line in file:lines() do
            table.insert(table_c, line)
        end
        file:close()
    end
    return table_c
end

function M.table_length()
    local table_test = M.read_table()
    local count = 0
    for _ in pairs(table_test)
    do
        count = count + 1
    end
    return count
end

function M.save_table(new_table)
    local file, err = io.open(contents, "w")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for num, item in ipairs(new_table) do
            if num == #new_table then
                file:write(item)
            else
                file:write(item .. "\n")
            end
        end
        file:close()
    end
end

function M.display_table()
    local main_table = M.read_table()
    local display_table = {}
    for num, item in ipairs(main_table) do
        local cheat_cmd = num .. " " .. item
        table.insert(display_table, cheat_cmd)
    end
    return display_table
end

function M.read_input()
    local note_command = vim.fn.input("Enter VIM Command > ")
    local note = vim.fn.input("Enter Description > ")
    if note_command:match('%S') == nil or note_command == 'none' or note:match('%S') == nil
    then
        return 'quit'
    else
        local note_to_add = note_command .. "," .. note .. "\n"
        return note_to_add
    end
end

-- replacement nui versions
function M.read_command_input()
    -- nui function here
    local input = Input({
        position = "50%",
        size = {
            width = 20,
        },
        border = {
            style = "single",
            text = {
                top = "Enter Command >",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        prompt = "> ",
        -- default_value = greeting,
        on_close = function()
            print("Input Closed!")
        end,
        on_submit = function(value)
            -- Replaces command_add
            local note_to_add = value .. "\n"

            -- Set checks here
            if note_to_add == '\n'
            then
                print("Not a command")
            else
                -- Finally add to table
                M.write_table(note_to_add)
                print("Command added to cheat sheet: " .. value)
            end
        end,
    })
    -- make
    input:mount()
    -- unmount component when cursor leaves buffer
    input:on(event.BufLeave, function()
        input:unmount()
    end)
end

function M.write_table(note_to_add)
    local main_table = M.read_table()
    table.insert(main_table, note_to_add)
    M.save_table(main_table)
end

function M.delete_from_table(num_to_delete)
    local main_table = M.read_table()
    table.remove(main_table, num_to_delete)
    M.save_table(main_table)
end

function M.command_delete()
    local main_table = M.read_table()
    local line_elements = {}
    for num, item in ipairs(main_table) do
        table.insert(line_elements, Menu.item(item, { id = num }))
    end
    local menu = Menu({
        position = "50%",
        size = {
            width = 50,
            height = M.table_length() + 2,
        },
        border = {
            style = "single",
            text = {
                top = "[Choose Command to Delete]",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        lines = line_elements,
        max_width = 20,
        keymap = {
            focus_next = { "j", "<Down>", "<Tab>" },
            focus_prev = { "k", "<Up>", "<S-Tab>" },
            close = { "q", "<C-c>" },
            submit = { "<CR>", "<Space>" },
        },
        on_close = function()
            print("Menu Closed!")
        end,
        on_submit = function(item)
            local delete_text = "Confirm delete note? " .. "'" .. item.text .. "'" .. " y/n? "
            local confirm_delete = vim.fn.input(delete_text)
            if confirm_delete == 'y'
            then
                vim.cmd('redraw')
                print("Deleting note " .. item.text)
                M.delete_from_table(item.id)
                vim.cmd('redraw')
                vim.print('Deleted note ' .. item.text)
            else
                vim.cmd('redraw')
                print("Not deleting " .. item.text)
            end
        end,
    })

    -- mount the component
    menu:mount()
end

-- M.command_delete()


return M
