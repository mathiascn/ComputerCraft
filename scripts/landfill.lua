--- Landfill Script
-- This script automates the process of filling an area with blocks using a turtle in Minecraft.
-- The turtle retrieves blocks from an ender chest and places them in a grid pattern to fill the specified area.
-- Usage: landfill <width> <depth> <channel>
-- <channel> specifies the ender chest channel to collect blocks from.

local scriptName = "landfill"
local args = {...}

-- Validate the number of arguments provided.
if #args < 3 then
    print("Usage: " .. scriptName .. " <width> <depth> <channel>")
    return
end

-- Parse and store command-line arguments.
local WIDTH = tonumber(args[1])
local DEPTH = tonumber(args[2])
local CHANNEL = args[3]

dofile("turtle_bot")

-- Validate the channel argument.
if not COLOR_CHANNELS[CHANNEL] then
    print(CHANNEL .. " is not a valid color channel.")
    return
end


-- Initialize the turtle bot and establish a connection.
local t = TurtleBot.new(scriptName, "North")
t:connect()

--- Select a block from the turtle's inventory to place.
-- This function selects the first available block in the turtle's inventory that is not an ender chest.
local function selectBlocks()
    for _, v in pairs(t:inventory()) do
        if v.name ~= ITEMS.enderChest.name then
            turtle.select(v.slot)
            break
        end
    end
end


--- Place a block in the specified direction.
-- The turtle places a block in the given direction: "up", "down", or forward (default).
-- @param direction The direction to place the block ("up", "down", or forward).
local function place(direction)
    local placeFunc = turtle.place
    if direction == "up" then
        placeFunc = turtle.placeUp
    elseif direction == "down" then
        placeFunc = turtle.placeDown
    end

    selectBlocks()
    placeFunc()
end


--- Collect blocks from the ender chest.
-- The turtle retrieves blocks from the specified ender chest channel to refill its inventory.
local function collectBlocks()
    for i=1, 2 do
        t:enderCollect(COLOR_CHANNELS[CHANNEL], 64)
    end
    t:dig("up")
end


--- Fill the area below the turtle with blocks.
-- The turtle moves down to the bottom of a column, then moves up, placing blocks to fill the column.
local function fill()
    local y = 0
    while t:down() do
        y = y + 1
        sleep(.5)
    end

    for _ = 1, y do
        t:up()
        place("down")
    end
end

--- Traverse a row, filling it with blocks.
-- The turtle moves forward, filling each cell in the row with blocks, and refuels and collects blocks as needed.
-- @param steps The number of steps (blocks) the turtle should move forward while filling the row.
local function traverseRow(steps)
    for _ = 1, steps do
        local inventory = t:inventory()
        if #inventory < 3 then
            collectBlocks()
        end
        fill()
        t:enderRefuel(2000, 5000, ITEMS.charcoal)
        t:dig("up")
        sleep(.5)
        t:forward()
    end
end


--- Main function to fill the entire area.
-- The turtle moves through the specified area in a zigzag pattern, filling it with blocks.
local function main()
    for w = 1, WIDTH do
        traverseRow(DEPTH - 1)
        if w ~= WIDTH then
            if w % 2 == 1 then
                t:right()
                traverseRow(1)
                t:right()
            else
                t:left()
                traverseRow(1)
                t:left()
            end
        end
    end
    -- Position the turtle to the start of the next row if necessary.
    if WIDTH % 2 == 0 then
        t:right()
        t:right()
        traverseRow(WIDTH - 1)
        t:right()
        t:right()
    end
end

t:execute(main)