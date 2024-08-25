--- Farmer Script
-- This script automates the farming process using a turtle in Minecraft.
-- The turtle plants, harvests, and manages crops in a grid pattern based on user-specified rows and columns.
-- Usage: farmer {<crops>} <rows> <columns>
-- <crops> should be a list of crop names, separated by commas. Available crops are listed when the script is run without arguments.

local args = {...}
local scriptName = "farmer"

dofile("turtle_bot")
dofile("timer")

-- Validate the number of arguments provided.
if #args < 3 then
    print("Usage: " .. scriptName .. " {<crops>} <rows> <columns>")
    print("Note: <crops> should be a list of crop names. Available crops: {" .. table.concat(map(CROPS, function(k, _) return k end), ", ") .. "}")
    return false
end

-- Initialize the turtle bot and establish a connection.
local t = TurtleBot.new(scriptName, "North")
t:connect()
local crops = {}


--- Validate and parse the crops argument.
-- This function splits the crops argument into individual crop names, validates them against available crops, and stores valid crops.
-- @return True if all crops are valid, otherwise false.
local function validateCrops()
    local cropsArg = splitString(args[1], ',')
    for _, crop in ipairs(cropsArg) do
        if not CROPS[crop] then
            print("Error: Invalid crop name '" .. crop .. "'")
            return false
        end
        table.insert(crops, CROPS[crop])
        print("Valid crop: " .. CROPS[crop].name)
    end
    return true
end



--- Harvest a crop if it is mature.
-- The turtle checks if the block below is a mature crop and harvests it if so.
-- @return True if a crop was harvested, otherwise false.
local function harvest()
    local success, data = turtle.inspectDown()
    if not success then return false end
    local validCropNames = map(crops, function(_, v) return v.name end)
    if not inList(data.name, validCropNames) then return false end

    local crop = find(CROPS, function(k, v)
        if v.name == data.name and v.mature == data.metadata then
            return v
        end
    end)

    if not crop then return false end

    t:dig("down")
    return true
end


--- Plant a seed if the block below is empty.
-- The turtle plants a seed from the specified crop list in the current position.
-- @param idx The index to determine which crop to plant (cycles through the crop list).
-- @return True if a seed was planted, otherwise false.
local function plant(idx)
    if turtle.detectDown() then return false end
    local crop = crops[(idx % #crops) + 1]

    if not t:selectItem(crop.seed) then return false end
    t:dig("down")
    turtle.placeDown()

    return true
end


--- Print farming status information.
-- Clears the console and prints current fuel level and sleep interval information.
-- @param interval The time in seconds that the turtle will sleep before starting the next farming cycle.
local function printInfo(interval)
    shell.run("clear")
    print("Current fuel level: " .. turtle.getFuelLevel() .. ".")
    print("Sleeping for " .. interval .. " seconds...")
end


--- Handle turning the turtle at the end of a row.
-- This function makes the turtle turn left or right based on its current column position and moves it forward.
-- @param column The current column number.
-- @param func Optional function to execute after turning.
local function handleTurn(column, func)
    local turn = nil
    if column % 2 == 1 then
        turn = function() t:right() end
    else
        turn = function() t:left() end
    end

    turn()
    if func ~= nil then func() end
    t:forward()
    turn()
end


--- Reset the turtle's position to the starting point.
-- After completing a farming cycle, the turtle returns to the starting position for the next cycle.
-- @param rows The number of rows in the farming grid.
-- @param columns The number of columns in the farming grid.
local function reset(rows, columns)
    if columns % 2 == 1 then
        t:left(2)
        t:forward(rows - 1)
    end
    t:right()
    t:forward(columns - 1)
    t:right()
end


--- Calculate the sleep interval based on crop growth time.
-- Determines how long the turtle should sleep before the next farming cycle, based on the growth speed of the crops.
-- @param elapsedTime The time elapsed during the current farming cycle.
-- @param minGrowthSpeed The minimum growth speed among the selected crops.
-- @return The calculated sleep interval in seconds.
local function getSleepInterval(elapsedTime, minGrowthSpeed)
    local interval = minGrowthSpeed - elapsedTime
    if interval < 0 then return 0 else return interval end
end


--- Collect seeds from the ender chest.
-- The turtle collects the required number of seeds for the next farming cycle from the ender chest.
-- @param seedMaxCount The maximum number of seeds to collect for each crop.
local function getSeeds(seedMaxCount)
    for _, crop in pairs(crops) do
        t:enderCollect(crop.channel, seedMaxCount)
    end
end


--- Main farming function.
-- This function controls the overall farming process, handling planting, harvesting, refueling, and waiting for crops to grow.
local function main()
    if not validateCrops() then return end
    local rows = tonumber(args[2])
    local columns = tonumber(args[3])
    local timer = Timer.new()
    local minGrowthSpeed = math.min(
        unpack(
            map(crops, function(_, v) return v.speed end)
        )
    )
    local seedMaxCount = rows * columns / #crops
    t:awaitInventory(ITEMS.enderChest)

    while true do
        getSeeds(seedMaxCount)
        t:dig("up")

        timer:reset()
        timer:start()
        for c = 1, columns do
            for r = 2, rows do -- Turtle is already in the first cell
                harvest()
                plant(c+r)
                t:forward()
                if r == rows and c ~= columns then
                    handleTurn(c, function() harvest(); plant(c+r+1); end)
                end
            end
        end

        harvest()
        plant(columns+rows+1)
        reset(rows, columns)
        t:combine()
        t:enderDeposit(COLOR_CHANNELS.farmingDepot, {})
        t:enderRefuel(1000, 2000, ITEMS.charcoal)
        t:dig("up")

        timer:stop()
        local interval = getSleepInterval(timer.elapsedTime, minGrowthSpeed)
        printInfo(interval)
        sleep(interval)
    end
end

-- Execute the main function within the turtle bot's control context.
t:execute(main)