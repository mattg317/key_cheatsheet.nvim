local Popup = require("nui.popup")
local Input = require("nui.input")
local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
-- start table functions
local contents = "/Users/mgiordanella/Main/10_Coding/10_Nvim/key_cheatsheet.nvim/lua/cheatsheet/files/sample.txt"

local M = {}
-- Reading Table
-- start table functions


-- 1. READ TABLE
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

--- Display Table
function M.display_table(table_c)
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

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
    -- set content
    local display_table = {}
    for num, item in ipairs(table_c) do
        local cheat_cmd = num .. " - " .. item
        table.insert(display_table, cheat_cmd)
    end
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, display_table)

    local ok = popup:map("n", "q", function(bufnr)
        popup:unmount()
    end, { noremap = true })
end

-- Save Table
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

-- Write Table
function M.write_table(note_to_add)
    local main_table = M.read_table()
    table.insert(main_table, note_to_add)
    M.save_table(main_table)
end

-- Take Input
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

-- Delete from Table

-- Testing
-- bascially will want to run the read command twice and return the value?
-- local first = M.read_command_input()
local table_c = M.read_table()
M.display_table(table_c)
-- local note_to_add = M.read_command_input()
