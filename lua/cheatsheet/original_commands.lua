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
            -- Add handling for quiting with adding
            if note_to_add == 'quit'
            then
                vim.cmd('redraw')
                print("Quitting no note added")
                return
            else
                table_control.write_table(note_to_add)
                vim.cmd('redraw')
                vim.print("Added note " .. note_to_add)
            end
        end,
    },
    {
        name = "CheatSheetDelete",
        opts = {
            desc = "cheatsheet: delete",
            bar = true,
        },
        command = function()
            local to_delete = tonumber(vim.fn.input("Note to delete (enter 0 to quit)> ")) -- moves to vim commands
            if to_delete == 0
            then
                vim.cmd('redraw')
                print("Quitting note to delete")
                return
            else
                -- Is it possible to read that file and get the notes
                local confirm_delete = vim.fn.input("Are you sure you want to delete note "
                    .. to_delete .. "? - y/n ")
                if confirm_delete == 'y'
                then
                    vim.cmd('redraw')
                    print("Deleting note " .. to_delete)
                    table_control.delete_from_table(to_delete)
                    vim.cmd('redraw')
                    vim.print('Deleted note '.. to_delete)
                else
                    vim.cmd('redraw')
                    print("Not deleting " .. to_delete)
                end
            end
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
