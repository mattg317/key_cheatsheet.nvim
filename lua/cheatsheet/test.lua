local table_control = require("cheatsheet.table_control")

local M             = {}
M.test_delete       = function()
    local main_table = table_control.read_table()
    for num, item in ipairs(main_table) do
        print(num .. " - " .. item)
    end
    local note_command = vim.fn.input("Which number note to delete?")
end

M.test_delete()
return M
