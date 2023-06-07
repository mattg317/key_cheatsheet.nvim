local M = {}
local api = vim.api

M.open = function() 
    local width = 50
    local height = 10

    local buf = api.nvim_create_buf(false, true)

    -- Create border
    local horizontal_border = "+" .. string.rep("-", width - 2) .. "+"
    local empty_line = "|" .. string.rep(" ", width - 2) .. "|"
    -- local lines = 
    -- local lines = {hoizontal_border, empty_line}
    local lines = {horizontal_border}
    for var=1,height-2 do
        table.insert(lines, empty_line)
    end
    table.insert(lines, horizontal_border)


    api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- Set text
    -- TODO: create a list of cheets
    local messages = {
        "<CR> - Select auto suggestions",
        ":%s/foo/bar/g - Find and replace all",
    }
    -- will need to loop through to get the 
    local table_length = 0
    for _ in pairs(messages) do
        table_length = table_length + 1
    end

    -- add one for find and replace
    -- :%s/foo/bar/g - Find and replace all
    local offset = 0
    for _, line in ipairs(messages) do
        -- local start_col = (width - string.len(line))/2
        local start_col = 4
        local end_col = start_col + string.len(line)
        local current_row = height/2 - table_length/2 + offset
        offset = offset + 1
        api.nvim_buf_set_text(buf, current_row, start_col, current_row, end_col, {line})
    end


    local ui = api.nvim_list_uis()[1]

    local opts = {relative= 'editor',
     width= width,
     height= height,
     col= (ui.width/2) - (width/2),
    row = (ui.height/2) -(height/2),
    anchor= 'NW',
    style= 'minimal' }

    local win = api.nvim_open_win(buf, 1, opts)
    print("Window: " .. api.nvim_win_get_number(win))
    -- api.nvim_win_close(win, true)
    print(#api.nvim_list_wins())
    M.close()
end

function M.close()
    print("work")
    print(api.nvim_get_current_tabpage())
end

M.open()

return M
