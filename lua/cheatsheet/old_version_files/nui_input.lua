local Input = require("nui.input")
local M = {}
local function produce_output(command_string)
    local input_options = {
        position = "50%",
        size = {
            width = 20,
        },
        border = {
            style = "single",
            text = {
                top = command_string,
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }
    return input_options
end

function M.read_input()
    local command_action = ""
    local command_description = ""

    local input_options = produce_output("Enter command")
    print(input_options.position)
    local input = Input(input_options, 
        {
            prompt = "> ",
            default_value = "Hello",
            on_close = function()
                print("Input Closed!")
            end,
            on_submit = function(value)
                print("Input Submitted: " .. value)
                return value
            end,
            on_change = function(value)
                print("value Changed: " .. value)
            end,
        })
    input:mount()
    print("You entered: " .. input)

    -- local input_options = produce_output("Enter command action")
end

M.read_input()
return M
