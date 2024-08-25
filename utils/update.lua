--- Script to Update and Manage Files
-- This script updates Lua scripts from Pastebin by downloading them based on their hashes.
-- It also handles the copying of environment configuration files.

--- Updates a script by downloading it from Pastebin.
-- If the file at the given path already exists, it is deleted before downloading the new version.
-- @param hash The Pastebin hash of the script to be downloaded.
-- @param path The file path where the script will be saved.
local function updateScript(hash, path)
    if fs.exists(path) then
        fs.delete(path)
    end
    shell.run("pastebin get " .. hash .. " " .. path)
end


--- Main function to update all scripts and manage environment files.
-- This function loads the script mappings from the scripts file, updates each script by downloading the latest version from Pastebin,
-- and then manages the copying of the `.env` file to the `/disk` directory if it exists.
local function main()
    -- Load the script mappings from the specified file.
    -- @dofile("/disk/scripts") - Loads the `scripts.lua` file, which contains mappings for all scripts.
    local scripts = dofile("/disk/scripts")

    -- Update all scripts listed in the scripts table.
    -- Iterates over each script in the `scripts` table, updating it by downloading the latest version from Pastebin.
    -- @param v.hash The Pastebin hash of the script to be downloaded.
    -- @param v.name The name of the script file.
    -- @param v.directory The directory where the script will be saved.
    for _,v in pairs(scripts) do
        updateScript(v.hash, v.directory .. "/" .. v.name)
    end
    
    -- Copy the .env configuration file to the appropriate directory.
    -- If the .env file exists in the root directory, it is copied to the /disk directory.
    if fs.exists(".env") then
        fs.delete("/disk/.env")
        fs.copy(".env", "/disk/.env")
    end
end

main()