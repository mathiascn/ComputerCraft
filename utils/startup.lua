--- Script to Copy and Rename Turtle Scripts
-- This script manages the copying of scripts from a specified directory to the root of the turtle's file system.
-- It also handles renaming the turtle's startup script.

-- Load the scripts table from the specified file
-- @dofile("/disk/scripts") - Loads the `scripts.lua` file, which contains mappings for all scripts.
local scripts = dofile("/disk/scripts")

--- Add environment file configuration
-- Adds the `.env` file to the scripts table with its directory and type specified.
scripts.env =  {
    name = ".env",
    directory = "/disk",
    type = "turtle"
}


--- Copy turtle scripts to the root directory
-- Iterates over each script in the `scripts` table and copies it from its directory to the root of the turtle's file system.
-- @param v.name The name of the script file.
-- @param v.directory The directory where the script is located.
-- @param v.type The type of system the script is meant for (in this case, "turtle").
for _, v in pairs(scripts) do
    if v.type == "turtle" and fs.exists(v.directory) then
        print("Copying '" .. v.name .. "' to turtle...")
        fs.delete(v.name)
        fs.copy(v.directory .. "/" .. v.name, v.name)
    end
end


--- Rename the startup script if necessary
-- If the file "turtle_startup" exists, it renames it to "startup", ensuring the turtle runs the correct startup script on boot.
if fs.exists("turtle_startup") then
    if fs.exists("startup") then
        fs.delete("startup")
    end
    shell.run("rename turtle_startup startup")
end