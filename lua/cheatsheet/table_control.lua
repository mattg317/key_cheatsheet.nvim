local contents =
"/Users/mgiordanella/Main/10_Coding/10_Nvim/key_cheatsheet.nvim/lua/cheatsheet/files/sample.csv"

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
        local one, two = item:match("([^,]+),([^,]+)")
        local cheat_cmd = num .. " " .. one .. " - " .. two
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

function M.command_add()
    -- read input
    local note_to_add = M.read_input()

    if note_to_add == 'quit'
    then
        vim.cmd('redraw')
        print("Quitting no note added")
        return
    else
        local add_note_text = "Add note- " ..
            string.gsub(string.gsub(note_to_add, ',', ' '), '\n', '') .. "? (y/n)"
        local confirm_delete = vim.fn.input(add_note_text)
        if confirm_delete == 'y'
        then
            M.write_table(note_to_add)
            vim.cmd('redraw')
            vim.print("Added note " .. note_to_add)
        else
            vim.cmd('redraw')
            print("Not adding " .. note_to_add)
        end
    end
end

function M.command_delete()
    local main_table = M.read_table()
    for num, item in ipairs(main_table) do
        print(num .. " - " .. item)
    end

    local to_delete = tonumber(vim.fn.input("Note to delete (enter 0 to quit)> "))
    if to_delete == 0 or to_delete > M.table_length()
    then
        vim.cmd('redraw')
        print("Quitting note to delete")
        return
    else
        local table_list = M.read_table()
        local one, two = table_list[to_delete]:match("([^,]+),([^,]+)")
        local delete_text = "Confirm delete note " .. to_delete .. ": " .. one .. " " .. two .. "? " .. " y/n? "

        local confirm_delete = vim.fn.input(delete_text)
        if confirm_delete == 'y'
        then
            vim.cmd('redraw')
            print("Deleting note " .. to_delete)
            M.delete_from_table(to_delete)
            vim.cmd('redraw')
            vim.print('Deleted note ' .. to_delete)
        else
            vim.cmd('redraw')
            print("Not deleting " .. to_delete)
        end
    end
end

return M
