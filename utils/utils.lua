--- Global Type Checking Function
-- This function checks the type of a given value and raises an error if it does not match the expected type.
-- @param value The value to check the type of.
-- @param expectedType The expected type as a string (e.g., "string", "table").
-- @param functionName The name of the function calling this check, used for error reporting.
function _G.typeCheck(value, expectedType, functionName)
    if type(value) ~= expectedType then
        error("TypeError in " .. functionName .. ": Expected a " .. expectedType .. ", but received type '" .. type(value) .. "'.", 2)
    end
end


--- Find the Index of a Value in a Table
-- Searches through a table to find the index of a specific value.
-- @param t The table to search through.
-- @param value The value to find the index of.
-- @return The index of the value if found, or nil if not found.
function _G.findIndex(t, value)
    typeCheck(t, "table", "findIndex")
    typeCheck(value, "string", "findIndex")

    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end


--- Check if an Item Exists in a List
-- Determines whether a given item is present in a list (table).
-- @param item The item to search for.
-- @param t The table (list) to search within.
-- @return True if the item is found, otherwise false.
function _G.inList(item, t)
    typeCheck(item, "string", "inList")
    typeCheck(table, "table", "inList")

    for _, listValue in ipairs(t) do
        if item == listValue then return true end
    end
    return false
end


--- Load and Execute a Lua Script from File
-- Loads a Lua script from a file path, compiles it, and executes it.
-- @param filePath The path to the Lua script file.
-- @return The result of executing the loaded script.
function _G.require(filePath)
    typeCheck(filePath, "table", "printTable")

    local file = io.open(filePath, "r")
    if not file then
        error("Could not load file " .. filePath)
        return nil
    end
    local fileContent = file:read("*all")
    file:close()

    local chunk = load(fileContent, "@"..filePath)
    return chunk()
end


--- Pretty-Print a Table
-- Recursively prints a table's contents with indentation to show structure.
-- @param t The table to print.
-- @param indent The string used for indentation (optional, defaults to "").
function _G.printTable(t, indent)
    typeCheck(t, "table", "printTable")

    if indent ~= nil then
        typeCheck(indent, "string", "printTable")
    end
    indent = indent or ""
    for k, v in pairs(t) do
        if type(v) == "table" then
            print(indent .. k .. ": ")
            printTable(v, indent .. "  ")
        else
            print(indent .. k .. ": " .. tostring(v))
        end
    end
end


--- Apply a Function to Each Element in a Table
-- Applies a given function to each element in a table and returns a new table with the results.
-- @param t The table to iterate over.
-- @param func The function to apply to each element.
-- @param sequential Whether to use ipairs (sequential) or pairs for iteration (defaults to pairs).
-- @return A new table containing the results of the function applied to each element.
function _G.map(t, func, sequential)
    typeCheck(t, "table", "map")
    typeCheck(func, "function", "map")

    if sequential ~= nil then
        typeCheck(sequential, "boolean", "map")
    end

    local result = {}
    local iterator = sequential and ipairs or pairs

    for k, v in iterator(t) do
        table.insert(result, func(k, v))
    end
    return result
end


--- Find the First Element in a Table that Matches a Condition
-- Searches through a table and returns the first element that satisfies the provided function.
-- @param t The table to search through.
-- @param func The function to evaluate each element against.
-- @return The first element that matches the condition, or false if none found.
function _G.find(t, func)
    typeCheck(t, "table", "find")
    typeCheck(func, "function", "find")
    for k, v in pairs(t) do
        local result = func(k, v)
        if result ~= nil then return result end
    end
    return false
end


--- Split a String by a Delimiter
-- Splits a string into a table based on a delimiter (default is space).
-- @param str The string to split.
-- @param delimiter The delimiter to split by (optional, defaults to space).
-- @return A table containing the split parts of the string.
function _G.splitString(str, delimiter)
    delimiter = delimiter or " "
    typeCheck(delimiter, "string", "splitString")

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end


--- Load Environment Variables from a File
-- Loads environment variables from a file (e.g., .env) into a table.
-- Supports conversion of values to boolean or number types if applicable.
-- @param path The path to the environment file (optional, defaults to ".env").
-- @return A table containing the environment variables as key-value pairs.
function _G.loadEnv(path)
    local path = path or ".env"
    typeCheck(path, "string", "loadEnv")

    local env = {}
    if not fs.exists(path) then
        return env
    end
    local file = fs.open(path, "r")
    local line = file.readLine()
    while line do
        local key, value = line:match("([^=]+)=(.+)")
        if key and value then
            key = key:match("^%s*(.-)%s*$")  -- Trim whitespace from both ends of the key
            value = value:match("^%s*['\"]?(.-)['\"]?%s*$")  -- Trim and remove possible quotes
            if value == "true" then value = true -- Attempt boolean conversion
            elseif value == "false" then value = false -- Attempt boolean conversion
            elseif tonumber(value) then value = tonumber(value) -- Attempt number conversion
            end
            env[key] = value
        end
        line = file.readLine()
    end
    file.close()
    return env
end