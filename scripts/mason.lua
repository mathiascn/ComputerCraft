--- Mason Script
-- This script automates the construction of a wall using a turtle in Minecraft.
-- The turtle builds a wall of specified width and height, collecting blocks from an ender chest channel as needed.
-- Usage: mason <width> <height> <channel>
-- <channel> specifies the ender chest channel to collect blocks from.

local scriptName = "mason"
local args = {...}

-- Validate the number of arguments provided.
if #args < 3 then
    print("Usage: " .. scriptName .. " <width> <height> <channel>")
    return
end

-- Parse and store command-line arguments.
local WIDTH = tonumber(args[1])    -- Width of the wall to be built.
local HEIGHT = tonumber(args[2])   -- Height of the wall to be built.
local CHANNEL = args[3]            -- Channel to retrieve blocks from.

-- Validate the channel argument.
if not COLOR_CHANNELS[CHANNEL] then
    print(CHANNEL .. " is not a valid color channel.")
    return
end

dofile("turtle_bot")

-- Initialize the turtle bot and establish a connection.
local t = TurtleBot.new(scriptName, "North")
t:connect()


--- Select blocks from the turtle's inventory.
-- This function selects the first available block in the turtle's inventory that is not an ender chest.
local function selectBlocks()
    for k,v in pairs(t:inventory()) do
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


--- Build a standard segment of the wall.
-- This function places three blocks: one in the current position, one above, and one below.
local function standardSegment()
    place()
    place("down")
    place("up")
end


--- Build the first segment of the wall.
-- This function places two blocks: one above and one below the current position.
local function firstSegment()
    place("down")
    place("up")
end


--- Build the last segment of the wall.
-- This function places three blocks: one in the current position, then moves up and places two more blocks below.
local function lastSegment()
    place()
    place("down")
    t:up()
    place("down")
    t:up()
    place("down")
end

--- Turn the turtle around to start a new row.
-- The turtle turns 180 degrees to begin building the next row of the wall.
local function turnAround()
    t:right()
    t:right()
end

--- Build the wall layer by layer.
-- The turtle builds the wall by moving up in steps of three, placing blocks as it goes.
local function build()
    for h=1, HEIGHT, 3 do
        t:up()
        turnAround()
        firstSegment()
        t:back()
        for w=1, WIDTH - 2 do
            standardSegment()
            t:back()
        end
        lastSegment()
    end
end


--- Collect blocks from the ender chest.
-- The turtle retrieves the necessary number of blocks from the specified ender chest channel to complete the wall.
local function collectBlocks()
    local stacks = math.ceil(HEIGHT * WIDTH / 64)
    for i=1, stacks do
        t:enderCollect(COLOR_CHANNELS[CHANNEL], 64)
    end
    t:dig("up")
end


--- Main function to control the wall-building process.
-- The turtle collects blocks, builds the wall, and repeats the process as needed.
local function main()
    collectBlocks()
    build()
end

-- Execute the main function within the turtle bot's control context.
t:execute(main)