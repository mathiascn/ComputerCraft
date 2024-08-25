--- Lumberjack Script
-- This script automates the process of chopping down trees and replanting saplings using a turtle in Minecraft.
-- The turtle moves through rows of trees, chops them down, collects the logs, and replants saplings.
-- Usage: lumberjack <rows> <number of trees> <sleep interval>
-- <rows> is the number of rows of trees, <number of trees> is the number of trees per row, and <sleep interval> is the time in seconds the turtle waits between cycles.

local args = {...}
local scriptName = "lumberjack"

-- Validate the number of arguments provided.
if #args < 3 then
    print("Usage: " .. scriptName.. " <rows> <number of trees> <sleep interval>")
    return
end

-- Parse and store command-line arguments.
local rowsToChop = tonumber(args[1])          -- Number of rows of trees to chop.
local treesPerRow = tonumber(args[2])         -- Number of trees per row.
local sleepInterval = tonumber(args[3])       -- Time in seconds between cycles.
local treeCount = rowsToChop * treesPerRow * 2-- Total number of trees in the farm.
local logTally = 0                            -- Counter for logs collected.
local depositErrors = 0                       -- Counter for deposit errors.

dofile("turtle_bot")

-- Initialize the turtle bot and establish a connection.
local t = TurtleBot.new(scriptName, "West")
t:connect()


--- Plant a sapling in the current position.
-- The turtle checks if the block ahead is clear, selects a sapling from its inventory, and plants it.
-- If the turtle runs out of saplings, an error is raised.
local function plant()
    if turtle.detect() then return end
    if t:selectItem(ITEMS.sapling.name) then return turtle.place() end
    error("Ran out of saplings to plant", 2)
end

--- Check if the block in the specified direction is a log.
-- @param direction The direction to check for a log (default is "front").
-- @return True if the block is a log, otherwise false.
local function isLog(direction)
    direction = direction or "front"
    return t:detectBlock({BLOCKS.log.name}, direction)
end

--- Check if the block in the specified direction is choppable (log or leaves).
-- @param direction The direction to check for choppable blocks (default is "front").
-- @return True if the block is choppable, otherwise false.
local function isChoppable(direction)
    return t:detectBlock({BLOCKS.log.name, BLOCKS.leaves.name}, direction)
end

--- Move the turtle down until it reaches the ground, chopping any logs in the way.
-- The turtle digs down if it detects a choppable block, and moves down until it reaches the ground.
local function goDown()
    while true do
        local success, _ = turtle.inspectDown()
        if success then
            if isChoppable("down") then
                t:dig("down")
            else
                return true
            end
        end
        t:down()
    end
end

--- Chop a log in the specified direction.
-- The turtle chops the block in the given direction if it is choppable, and increments the log tally if it is a log.
-- @param direction The direction to chop (default is "front").
-- @return True if a log was chopped, otherwise false.
local function chopLog(direction)
    direction = direction or "front"
    if not isChoppable(direction) then return false end
    if isLog(direction) then logTally = logTally + 1 end
    t:dig(direction)
end

--- Chop a layer of logs around the turtle.
-- The turtle chops logs in a 4-block area around it and above it, turning to face each direction.
-- @param iteration The current iteration of chopping (used to control behavior).
local function chopLayer(iteration)
    chopLog("up")
    for i = 1, 4 do
        chopLog()
        if iteration ~= 1 then
            turtle.turnRight()
            turtle.suck()
        end
    end
end

--- Chop down an entire tree.
-- The turtle chops down a tree by moving up layer by layer, chopping logs, and then returns to the ground.
local function chopTree()
    local i = 1
    while isLog() do
        chopLayer(i)
        t:up()
        i = i + 1
    end

    goDown()
end


--- Chop a row of trees.
-- The turtle moves along a row of trees, chopping each tree, collecting drops, and replanting saplings.
local function chopRow()
    for tree=1, treesPerRow do
        chopTree()
        turtle.suck()
        plant()
        t:right()
        turtle.suck()
        if tree ~= treesPerRow then
            t:forward()
            t:left()
        else
            t:right()
            t:forward()
        end
    end
    t:updateData()
    for tree=1, treesPerRow do
        chopTree()
        turtle.suck()
        plant()
        t:right()
        turtle.suck()
        if tree ~= treesPerRow then
            t:forward()
            t:left()
        end
    end
    t:updateData()
end


--- Move the turtle to the next row.
-- The turtle moves to the next row of trees to continue chopping.
local function switchRow()
    t:forward()
    t:left()
    t:forward(3)
    t:left()
    t:forward()
    t:left()
end


--- Print the current status information.
-- Clears the console and prints the number of deposit errors, logs chopped, total trees in the farm, and the current fuel level.
local function printInfo()
    shell.run("clear")
    print("Deposit errors: " .. depositErrors .. ".")
    print("Logs chopped: " .. logTally .. ".")
    print("Trees in my farm: " .. treeCount .. "!")
    print("Current fuel level: " .. turtle.getFuelLevel() .. ".")
    print("Sleeping for " .. sleepInterval .. " seconds...")
end


--- Reset the turtle's position and manage inventory.
-- The turtle returns to the starting position, combines inventory, deposits logs, and refuels.
local function reset()
    local blocks_to_path = (rowsToChop - 1) * 4 + 1
    t:forward()
    t:right()
    t:forward(blocks_to_path)
    t:right()
    t:combine()
    t:enderDeposit(COLOR_CHANNELS.farmingDepot, {})
    t:enderRefuel(2000, 5000, ITEMS.charcoal)
end


--- Main function to control the lumberjack process.
-- The turtle collects saplings, chops down trees row by row, resets its position, and repeats the process.
local function main()
    while true do
        t:enderCollect(COLOR_CHANNELS.sapling, treeCount)
        t:forward()
        t:left()
        for row = 1, rowsToChop do
            chopRow()
            if row ~= rowsToChop then
                switchRow()
            end
        end
        reset()
        printInfo()
        sleep(sleepInterval)
    end
end

t:execute(main)