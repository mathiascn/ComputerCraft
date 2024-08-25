--- Quick Tool Lua Interactive Shell
-- This script provides an interactive Lua shell environment, allowing users to execute Lua code, 
-- load scripts from files, and get autocomplete suggestions based on global variables.
local args = {...}
local history = {}


--- Lists the keys of a given table.
-- This function iterates over a table and collects all the keys into a list.
-- @param tbl The table whose keys are to be listed.
-- @return A list of keys from the table.
local function listTableKeys(tbl)
    local list = {}
    for key, _ in pairs(tbl) do
        table.insert(list, key)
    end
    return list
end


--- Executes a given piece of Lua code.
-- This function attempts to load and execute Lua code provided as a string. It handles both syntax and runtime errors.
-- @param code The Lua code to be executed.
local function executeCode(code)
    local func, syntaxError = load(code, "user_input", "t", _G)
    if func then
        local success, runtimeError = pcall(func)
        if not success then
            print("Error: " .. runtimeError)
        end
    else
        print("Syntax error: " .. syntaxError)
    end
end


--- Loads and executes a Lua script from a file.
-- If a filename is provided as the first argument, this function attempts to load the file,
-- read its contents, and execute the script.
-- @param args[1] The name of the file to load and execute (optional).
if args[1] then
    local file = fs.open(args[1], "r")
    if file then
        local script = file.readAll()
        file.close()
        executeCode(script)
    else
        print("Could not open file: " .. args[1])
    end
end


--- Completion function for the read function.
-- This function provides autocomplete suggestions based on the current input line,
-- matching against global variables.
-- @param line The current input line being typed by the user.
-- @return A list of possible completions based on the global environment (_G).
local function complete(line)
    local results = {}
    local part = line:match("%S+$") or ""
    for k, v in pairs(_G) do
        if k:sub(1, #part) == part then
            table.insert(results, k)
        end
    end
    return results
end

--- Interactive shell loop.
-- This loop continuously prompts the user for input, executes the entered code, and adds it to the command history.
-- It also updates the list of choices for autocompletion after each command.
local choices = listTableKeys(_G)
while true do
    write("qt> ")
    local cmd = read(nil, history, complete)
    table.insert(history, cmd)
    choices = listTableKeys(_G)
    executeCode(cmd)
end
