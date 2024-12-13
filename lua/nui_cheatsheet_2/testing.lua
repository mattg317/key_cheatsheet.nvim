local contents = vim.fn.stdpath('data') .. "/cheat_test_delete/"

-- if vim.fn.isdirectory(contents) == 1 then
--     print("Exists")
--     local file, err = io.open(contents .. "/delete_me.txt", "w")
--     if file == nil then
--         print("Couldn't open file: " .. err)
--     else
--         file:write("Your first command")
--         file:close()
--     end
-- else
--     print("Doesn't exist creating" .. contents)
--     vim.fn.mkdir(contents)
-- end

-- checking if file exist
-- function file_exists(name)
--    local f=io.open(name,"r")
--    if f~=nil then io.close(f) return true else return false end
-- end


-- print(vim.fn.isdirectory(contents))
