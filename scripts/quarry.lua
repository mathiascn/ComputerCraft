--- Quarry Script
-- This script automates the process of mining out a quarry using a turtle in Minecraft.
-- The turtle will mine layer by layer, depositing mined resources in an ender chest and refueling as needed.
-- Usage: quarry <turtle y coordinate> <height to start mining>
-- <turtle y coordinate> is the starting height of the turtle, and <height to start mining> is the depth at which mining begins.

local args = {...}
local scriptName = "quarry"

-- Validate the number of arguments provided.
if #args < 2 then
    print("Usage: " .. scriptName .. " <turtle y coordinate> <height to start mining>")
    return
end

-- Parse and store command-line arguments.
local startingHeight = tonumber(args[1])
local miningStart = tonumber(args[2])
local chunkSize = 32

dofile("turtle_bot")

-- Initialize the turtle bot and establish a connection.
local t = TurtleBot.new(scriptName, "North")
t:connect()


--- Mine a block in the specified direction.
-- The turtle will mine a block in the given direction (default is "front"). 
-- If the turtle's inventory is nearly full, it will deposit items in the ender chest.
-- @param direction The direction to mine ("front", "up", or "down").
local function mine(direction)
    direction = direction or "front"
    local detect = turtle.detect

    if direction == "up" then
        detect = turtle.detectUp
    elseif direction == "down" then
        detect = turtle.detectDown
    end

    while detect() do
        t:dig(direction)
        sleep(.5)
    end

    local inventory = t:inventory()

    if #inventory > 10 then
        t:enderDeposit(COLOR_CHANNELS.miningDepot, {})
        t:dig("up")
    end
end


--- Mine a row of blocks.
-- The turtle will mine a row of blocks in the current direction, refueling and depositing items as needed.
-- @param steps The number of blocks to mine forward.
local function mineRow(steps)
    t:updateData()
    for _ = 1, steps do
        mine()
        t:enderRefuel(2000, 5000, ITEMS.charcoal)
        t:dig("up")
        t:forward()
    end
end


--- Handle turning the turtle at the end of a row.
-- This function makes the turtle turn left or right at the end of a row, depending on the layer and row index.
-- @param layer The current layer being mined.
-- @param idx The current row index within the layer.
local function handleTurn(layer, idx)
    local evenLayer = layer % 2 == 0
    local turn = nil
    if idx % 2 == 1 ~= evenLayer then
        turn = function() t:right() end
    else
        turn = function() t:left() end
    end
    turn()
    mine()
    t:forward()
    turn()
end


--- Mine an entire layer of the quarry.
-- The turtle will mine an entire 32x32 layer, moving row by row.
-- @param layer The current layer being mined.
local function mineLayer(layer)
    for idx = 1, chunkSize do
        mineRow(chunkSize - 1)
        if idx ~= chunkSize then
            handleTurn(layer, idx)
        else
            t:left(2)
        end
    end
end


--- Main function to control the quarry mining process.
-- The turtle will descend to the starting mining height and then begin mining out the quarry layer by layer.
-- After mining is complete, the turtle returns to the surface.
local function main()
    t:awaitInventory(ITEMS.enderChest)

    for layer = 1, startingHeight do
        if startingHeight - layer >= miningStart then
            t:dig("down")
            t:down()
        else
            mineLayer(layer)
            if layer ~= startingHeight then
                mine("down")
                t:down()
            end
        end
    end
    for i = 1, startingHeight + 2 do
        t:dig("up")
        t:up()
    end
end

-- Execute the main function within the turtle bot's control context.
t:execute(main)