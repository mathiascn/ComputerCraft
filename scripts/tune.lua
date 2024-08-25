--- Tune Script
-- This script tunes an Ender Chest in Minecraft to a specific channel using a turtle.
-- The turtle must be facing an Ender Chest, and the script will configure the chest's colors based on the specified channel.
-- Usage: tune <channel>
-- <channel> specifies the ender chest channel to set.

local scriptName = "tune"
local args = {...}

-- Validate the number of arguments provided.
if #args < 1 then
    print("Usage: " .. scriptName .. " <channel>")
    return
end

-- Parse and store the channel argument.
local CHANNEL = args[1]
dofile("constants")

-- Validate the channel argument.
if not COLOR_CHANNELS[CHANNEL] then
    print(CHANNEL .. " is not a valid color channel.")
    return
end

-- Inspect the block in front of the turtle to ensure it is an Ender Chest.
local success, data = turtle.inspect()
if not success or data.name ~= BLOCKS.enderChest.name then
    print("Place an ender chest in front of the turtle")
    return
end

-- Wrap the Ender Chest peripheral.
local enderChest = peripheral.wrap("front")
if enderChest == nil then
    print("Failed to connect to ender chest")
    return
end

-- Set the Ender Chest colors to the specified channel.
enderChest.setColors(unpack(COLOR_CHANNELS[CHANNEL]))
print("Ender chest is now tuned to: '" .. CHANNEL .. "'")