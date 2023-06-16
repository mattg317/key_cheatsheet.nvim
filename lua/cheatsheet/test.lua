local contents = "/Users/mgiordanella/Desktop/nvim_custom_plugins/key_cheatsheet.nvim/lua/cheatsheet/files/sample.csv"

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

function M.save_table(table_c)
    local file, err = io.open(contents, "w")
    if file == nil then
        print("Couldn't open file: " .. err)
    else
        for _, item in ipairs(table_c) do
            file:write(item .. "\n")
        end
    file:close()
    end
end

function M.display_table(table_c)
    local display_table = {}
    for num, item in ipairs(table_c) do
            local one,two = item:match("([^,]+),([^,]+)")
            local cheat_cmd = num .. " " .. one .. " - " .. two
            table.insert(display_table, cheat_cmd)
        end
    return display_table
end


function M.read_input()
     local note_command = vim.fn.input("New Note > ")
     local note = vim.fn.input("Enter Note command > ")
     local note_to_add = note_command .. "," .. note .. "\n"
     return note_to_add
end


-- Write Table
-- local note_to_add = read_input() -- moves to vim command
function M.write_table(note_to_add)
    local main_table = M.read_table()
    table.insert(main_table, note_to_add)
    M.save_table(main_table)
end

-- Delete table
-- local to_delete = tonumber(vim.fn.input("Note to delete > ")) -- moves to vim commands
function M.delete_from_table( num_to_delete)
    local main_table = M.read_table()
    table.remove(main_table, num_to_delete)
    M.save_table(main_table)
end

return M
