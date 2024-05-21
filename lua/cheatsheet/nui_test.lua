local Popup = require("nui.popup")
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local contents_file = require("cheatsheet.table_control")
local M = {}

-- start table functions
local contents =
"/Users/mgiordanella/Main/30-39_Coding/30_Nvim/nvim_custom_plugins/key_cheatsheet.nvim/lua/cheatsheet/files/test.csv"

local function read_table()
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

local function save_table(new_table)
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

local function write_table(note_to_add)
    local main_table = read_table()
    table.insert(main_table, note_to_add)
    save_table(main_table)
end


-- End table Functions
local function create_popup(greeting)
    local input = Input({
        position = "50%",
        size = {
            width = 20,
        },
        border = {
            style = "single",
            text = {
                top = greeting,
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
            -- Could have it just manually type the note and add it, should be eaiser
            -- So add function to store in list here
            print("Command added to cheat sheet: " .. value)
            write_table(value)
        end,
    })

    -- mount/open the component
    -- input:mount()
    --
    -- -- unmount component when cursor leaves buffer
    -- input:on(event.BufLeave, function()
    --     input:unmount()
    -- end)
    return input
end

local test_command = create_popup('Enter Command')
-- mount/open the component
test_command:mount()
-- unmount component when cursor leaves buffer
test_command:on(event.BufLeave, function()
    test_command:unmount()
end)

-- print("Command entered" .. test_command)
-- Run input to get command
-- store the  result
-- then trigger input to run again
