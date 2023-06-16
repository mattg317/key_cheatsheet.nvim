local toggle = require("cheatsheet.menu")
local table_control = require("cheatsheet.table_control")

local M = {}


local CMDS = {
    {
        name = "CheatSheetToggle",
        opts = {
            desc = "cheatsheet: open",
            bar = true,
        },
        command = function()
            toggle.toggle_menu()
        end,
    },
    {
        name = "CheatSheetAdd",
        opts = {
            desc = "cheatsheet: add",
            bar = true,
        },
        command = function()
            -- read input
            local note_to_add = table_control.read_input()
            table_control.write_table(note_to_add)
        end,
    },
    {
        name = "CheatSheetDelete",
        opts = {
            desc = "cheatsheet: delete",
            bar = true,
        },
        command = function()
            local to_delete = tonumber(vim.fn.input("Note to delete > ")) -- moves to vim commands
            table_control.delete_from_table(to_delete)
        end
    },

}

function M.setup()
    for _, cmd in ipairs(CMDS) do
        local opts = vim.tbl_extend("force", cmd.opts, { force = true })
        vim.api.nvim_create_user_command(cmd.name, cmd.command, opts)
    end
end

return M
