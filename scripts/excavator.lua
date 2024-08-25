--- Excavator Script
-- This script controls a turtle to excavate a specified area within Minecraft.
-- The turtle can dig in layers from either the top or bottom, depending on user input.
-- Usage: excavator <width> <depth> <height> <start>
-- <start> should be 'top' or 'bottom'.

local scriptName = "excavator"
local args = {...}

-- Validate the number of arguments provided.
if #args < 4 then
    print("Usage: " .. scriptName .. " <width> <depth> <height> <start>")
    print("<start> should be 'top' or 'bottom'")
    return
end

-- Load the turtle bot control module.
dofile("turtle_bot")
local t = TurtleBot.new(scriptName, "North")
t:connect()

-- Parse and store command-line arguments.
local WIDTH = tonumber(args[1])  -- Width of the excavation area.
local DEPTH = tonumber(args[2])  -- Depth of the excavation area.
local HEIGHT = tonumber(args[3]) -- Height of the excavation area.
local START = args[4]            -- Start position, either "top" or "bottom".

-- Validate the start option.
if not inList(START, {"top", "bottom"}) then
    print("Invalid start option. Use 'top' or 'bottom'.")
    return
end


--- Mine a single row of blocks.
-- This function instructs the turtle to mine a row of blocks in the current direction.
-- If the turtle encounters an obstacle, it digs through it, and handles inventory and fuel management.
-- @param steps The number of steps (blocks) the turtle should move forward while mining.
local function mineRow(steps)
    for _ = 1, steps do
        while turtle.detect() do
            t:dig()

            local inventory = t:inventory()
            if #inventory > 10 then
                t:enderDeposit(COLOR_CHANNELS.miningDepot, {})
                t:dig("up")
            end

            t:enderRefuel(2000, 5000, ITEMS.charcoal)
            t:dig("up")
            sleep(.5)
        end
        t:forward()
    end
end


--- Mine an entire layer of the specified area.
-- This function mines a complete layer of the excavation area, moving the turtle in a zigzag pattern.
-- @param width The width of the layer to be mined.
-- @param depth The depth of the layer to be mined.
local function mineLayer(width, depth)
    for w = 1, width do
        mineRow(depth - 1)
        if w ~= width then
            if w % 2 == 1 then
                t:right()
                mineRow(1)
                t:right()
            else
                t:left()
                mineRow(1)
                t:left()
            end
        end
    end
    -- Position the turtle to the start of the next layer if necessary.
    if width % 2 == 0 then
        t:right()
        t:right()
        mineRow(width - 1)
        t:right()
        t:right()
    end
end


--- Main excavation function.
-- This function controls the overall excavation process, digging layer by layer based on the specified height.
-- The turtle will move up or down depending on the start option ("top" or "bottom").
local function main()
    for h = 1, HEIGHT do
        mineLayer(WIDTH, DEPTH)
        if h ~= HEIGHT then
            if START == "top" then
                t:dig("down")
                t:down()
            else
                t:dig("up")
                t:up()
            end
        end
    end
end

-- Execute the main function within the turtle bot's control context.
t:execute(main)