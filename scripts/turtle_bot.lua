--- TurtleBot Module
-- This module defines the TurtleBot class, which provides a variety of methods to manage a turtle's movement, inventory, and interaction with blocks in Minecraft.
-- The TurtleBot can connect to an API, update its status, execute tasks with continuous updates, and interact with Ender Chests for storage and refueling.


dofile("utils")
dofile("constants")
local ENV = loadEnv()

TurtleBot = {}
TurtleBot.__index = TurtleBot


--- Creates a new TurtleBot instance.
-- @param currentScript The name of the script currently running on the turtle.
-- @param direction The initial direction the turtle is facing.
-- @param x The initial x-coordinate of the turtle (default is 0).
-- @param y The initial y-coordinate of the turtle (default is 0).
-- @param z The initial z-coordinate of the turtle (default is 0).
-- @return A new TurtleBot instance.
function TurtleBot.new(currentScript, direction, x, y, z)
    local self = setmetatable({}, TurtleBot)
    self.label = os.computerLabel()
    self.fuelLevel = turtle.getFuelLevel()
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.direction = direction or "North"
    self.currentScript = currentScript or nil
    self.status = STATUS.STARTING
    return self
end

--- Connects the TurtleBot to the API using the API client.
function TurtleBot:connect()
    local apiClient = dofile("api_client")
    self.apiClient = apiClient.new(ENV.API)
end


--- Fetches data about the turtle from the server.
-- @return The data retrieved from the server.
function TurtleBot:fetchData()
    -- Fetch data about the turtle based on its label
    local path = "/turtles/" .. self.label
    return self.apiClient:get(path)
end

--- Updates the turtle's data on the server.
-- @return The result of the post request to the server.
function TurtleBot:updateData()
    -- Update the turtle data on the server
    self.fuelLevel = turtle.getFuelLevel()
    local data = {
        label = self.label,
        current_script = self.currentScript or "",
        coordinate_x = self.x,
        coordinate_y = self.y,
        coordinate_z = self.z,
        status = self.status,
        fuel_lvl = self.fuelLevel
    }
    local path = "/turtles"
    return pcall(function() self.apiClient:post(path, data) end)
end


--- Continuously updates the turtle's data on the server at regular intervals.
-- @param interval The interval in seconds between updates (default is 30 seconds).
function TurtleBot:continousUpdate(interval)
    if interval ~= nil then
        typeCheck(interval, "number", "TurtleBot:continousUpdate")
    end
    local interval = interval or 30
    while true do
        self:updateData()
        if inList(self.status, {STATUS.ERROR, STATUS.FINISHED}) then break end
        sleep(interval)
    end
end


--- Executes a function while continuously updating the turtle's status.
-- @param func The function to execute.
-- @param recovery An optional recovery function to execute if an error occurs.
function TurtleBot:execute(func, recovery)
    typeCheck(func, "function", "TurtleBot:execute")
    parallel.waitForAll(
        function() self:continousUpdate() end,
        function ()
            self.status = STATUS.RUNNING
            local status, err = pcall(func)
            if not status then
                print("Error occured: " .. err)
                self.status = STATUS.ERROR
                if type(recovery) == "function" then recovery() end
            else
                self.status = STATUS.FINISHED
            end
        end
    )
end


--- Helper function to move the turtle and update its position.
-- @param steps The number of steps to move (default is 1).
-- @param func The movement function to call (e.g., turtle.forward, turtle.back).
-- @param changeFunc A function to update the turtle's coordinates.
-- @return True if the movement was successful, otherwise false.
function TurtleBot:_movement(steps, func, changeFunc)
    steps = steps or 1
    typeCheck(steps, "number", "TurtleBot:_movement")
    typeCheck(func, "function", "TurtleBot:_movement")

    for i = 1, steps do
        local success = func()
        if not success then
            print("Movement function failed")
            return false
        end
        if changeFunc then changeFunc(self) end
    end
    return true
end


--- Helper function to update the turtle's direction after turning.
-- @param directionModifier A number to modify the current direction index (e.g., -1 for left, 1 for right).
function TurtleBot:_turn(directionModifier)
    typeCheck(directionModifier, "number", "TurtleBot:_turn")

    local dirIndex = (findIndex(DIRECTIONS, self.direction) + directionModifier - 1) % #DIRECTIONS + 1
    self.direction = DIRECTIONS[dirIndex]
end


--- Updates the turtle's coordinates after moving forward.
function TurtleBot:updatePositionForward()
    if self.direction == "North" then
        self.z = self.z - 1
    elseif self.direction == "South" then
        self.z = self.z + 1
    elseif self.direction == "East" then
        self.x = self.x + 1
    elseif self.direction == "West" then
        self.x = self.x - 1
    end
end

--- Updates the turtle's coordinates after moving backward.
function TurtleBot:updatePositionBackward()
    if self.direction == "North" then
        self.z = self.z + 1
    elseif self.direction == "South" then
        self.z = self.z - 1
    elseif self.direction == "East" then
        self.x = self.x - 1
    elseif self.direction == "West" then
        self.x = self.x + 1
    end
end


--- Moves the turtle forward.
-- @param steps The number of steps to move forward (default is 1).
-- @return True if the movement was successful, otherwise false.
function TurtleBot:forward(steps)
    return self:_movement(steps, turtle.forward, self.updatePositionForward)
end

--- Moves the turtle backward.
-- @param steps The number of steps to move backward (default is 1).
-- @return True if the movement was successful, otherwise false.
function TurtleBot:back(steps)
    return self:_movement(steps, turtle.back, self.updatePositionBackward)
end

--- Moves the turtle down.
-- @param steps The number of steps to move down (default is 1).
-- @return True if the movement was successful, otherwise false.
function TurtleBot:down(steps)
    return self:_movement(steps, turtle.down, function() self.y = self.y - 1 end)
end

--- Moves the turtle up.
-- @param steps The number of steps to move up (default is 1).
-- @return True if the movement was successful, otherwise false.
function TurtleBot:up(steps)
    return self:_movement(steps, turtle.up, function() self.y = self.y + 1 end)
end

--- Turns the turtle left.
-- @param steps The number of 90-degree turns to the left (default is 1).
-- @return True if the turn was successful, otherwise false.
function TurtleBot:left(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.turnLeft()
        self:_turn(-1)
    end
    return true
end

--- Turns the turtle right.
-- @param steps The number of 90-degree turns to the right (default is 1).
-- @return True if the turn was successful, otherwise false.
function TurtleBot:right(steps)
    steps = steps or 1
    for i = 1, steps do
        turtle.turnRight()
        self:_turn(1)
    end
    return true
end


--- Retrieves the turtle's inventory.
-- @return A table containing details about each item in the turtle's inventory.
function TurtleBot:inventory()
    local inventory = {}
    for slot = 1, 16 do
        local itemDetail = turtle.getItemDetail(slot)
        if itemDetail then
            itemDetail.slot = slot
            itemDetail.space = turtle.getItemSpace(slot)
            table.insert(inventory, itemDetail)
        end
    end
    return inventory
end

--- Combines identical items in the turtle's inventory to maximize space.
function TurtleBot:combine()
    local inventory = self:inventory()
    for i=1, #inventory do
        local itemI = inventory[i]
        if i == #inventory then break end -- Last item in the inventory does not have any existing slots to match
        if itemI.count ~= 0 then --Skip slot if count is exhausted
            for j=i + 1, #inventory do -- Loop through the remaining inventory to find more of this item
                local itemJ = inventory[j]
                if itemI.space == 0 then break end --ItemI has no more space left. Skipping to next item.
                if itemJ.count ~= 0  and itemJ.name == itemI.name and itemJ.damage == itemI.damage then -- Determining that the items are identical and that there are more items left.
                    turtle.select(itemJ.slot) --Slot is selected because there are items here we want in another stack.
                    local transferAmount = math.min(itemJ.count, itemI.space) -- We cant move more than itemJ has or itemI has space for
                    turtle.transferTo(itemI.slot, transferAmount)
                    itemI.space = itemI.space - transferAmount
                    itemI.count = itemI.count + transferAmount
                    itemJ.count = itemJ.count - transferAmount
                    itemJ.space = itemJ.space + transferAmount
                end
            end
        end
    end
end


--- Selects an item in the turtle's inventory by name.
-- @param itemName The name of the item to select.
-- @param itemDamage Optional parameter to specify the damage value of the item.
-- @return True if the item was found and selected, otherwise false.
function TurtleBot:selectItem(itemName, itemDamage)
    typeCheck(itemName, "string", "selectItem")
    for _,v in pairs(self:inventory()) do
        if v.name == itemName then
            if itemDamage ~= nil and v.damage ~= itemDamage then return false end
            turtle.select(v.slot)
            return true
        end
    end
    return false
end


--- Digs a block in the specified direction.
-- @param direction The direction to dig ("front", "up", or "down").
-- @return True if the block was successfully dug, otherwise false.
function TurtleBot:dig(direction)
    -- This could be expanded to track blocks dug
    direction = direction or "front"
    local digMethod = turtle.dig

    if direction == "front" then
        digMethod = turtle.dig
    elseif direction == "up" then
        digMethod = turtle.digUp
    elseif direction == "down" then
        digMethod = turtle.digDown
    else
        error("Unexpected dig direction: " .. direction, 2)
    end

    return digMethod()
end


--- Detects a specific block in the specified direction.
-- @param blocks A table of block names to detect.
-- @param direction The direction to inspect ("front", "up", or "down").
-- @return True if one of the specified blocks is detected, otherwise false.
function TurtleBot:detectBlock(blocks, direction)
    direction = direction or "front"
    local inspect_method = turtle.inspect

    if direction == "down" then
        inspect_method = turtle.inspectDown
    elseif direction == "up" then
        inspect_method = turtle.inspectUp
    end

    local success, data = inspect_method()

    if not success then return false end
    if not inList(data.name, blocks) then return false end
    return true
end


--- Places an Ender Chest and sets its color channel.
-- @param channel A table representing the color channel to set on the Ender Chest.
-- @return True if the Ender Chest was successfully placed and configured, otherwise false.
function TurtleBot:enderPlaceChest(channel)
    typeCheck(channel, "table", "TurtleBot:enderPlaceChest")
    -- A bug/instability in computercraft or minecraft
    -- causes peripheral.wrap to catch a java runtime error
    local success, error = pcall(function()
        local inspectResult, data = turtle.inspectUp()
        -- Checking if there is already an enderchest placed.
        -- If there is, all we do is change the channel
        if not inspectResult or data.name ~= BLOCKS.enderChest.name then
            if not self:selectItem(ITEMS.enderChest.name) then error("Missing Ender Chest", 2) end
            self:dig("up")
            turtle.placeUp()
        end
        local enderChest = peripheral.wrap("top")
        enderChest.setColors(unpack(channel))
    end)
    if type(error) == "string" then
        print("Caught an error while wrapping ender chest" .. error)
        self:dig("up")
    end
    return success
end


--- Collects items from an Ender Chest using the specified channel.
-- @param channel A table representing the color channel to set on the Ender Chest.
-- @param count The number of items to collect.
-- @return True if the items were successfully collected, otherwise false.
function TurtleBot:enderCollect(channel, count)
    typeCheck(channel, "table", "TurtleBot:enderCollect")
    typeCheck(count, "number", "TurtleBot:enderCollect")

    if not self:enderPlaceChest(channel) then return false end
    return turtle.suckUp(count)
end


--- Refuels the turtle using items collected from an Ender Chest.
-- @param lowFuel The fuel level at which refueling should start.
-- @param maxFuel The fuel level to reach before stopping refueling.
-- @param item A table representing the item to use for refueling.
function TurtleBot:enderRefuel(lowFuel, maxFuel, item)
    typeCheck(lowFuel, "number", "TurtleBot:enderRefuel")
    typeCheck(maxFuel, "number", "TurtleBot:enderRefuel")
    typeCheck(item, "table", "TurtleBot:enderRefuel")

    local fuelLvl = turtle.getFuelLevel()
    if fuelLvl > lowFuel then return end

    while turtle.getFuelLevel() < maxFuel do
        self:enderCollect(COLOR_CHANNELS.fuel, 64)
        self:selectItem(item.name, item.damage)
        turtle.refuel()
        sleep(1)
    end
end

--- Deposits items into an Ender Chest using the specified channel, avoiding items on the blacklist.
-- @param channel A table representing the color channel to set on the Ender Chest.
-- @param blacklist A table of item names that should not be deposited.
-- @return True if the items were successfully deposited, otherwise false.
function TurtleBot:enderDeposit(channel, blacklist)
    typeCheck(channel, "table", "TurtleBot:enderDeposit")
    typeCheck(blacklist, "table", "TurtleBot:enderDeposit")
    table.insert(blacklist, ITEMS.enderChest.name) -- Making sure we never deposit enderChest

    if not self:enderPlaceChest(channel) then return false end

    local result = true
    for _, v in pairs(self:inventory()) do
        if not inList(v.name, blacklist) then
            turtle.select(v.slot)
            result = turtle.dropUp()
        end
    end

    return result
end


--- Waits until a specific item appears in the turtle's inventory.
-- @param item A table representing the item to wait for.
-- @return True if the item appeared in the inventory, otherwise false if timed out.
function TurtleBot:awaitInventory(item)
    dofile("timer")
    local timer = Timer.new()
    local timeout = 300
    
    timer:start()
    while true do
        timer:stop()
        if timer.elapsedTime > timeout then
            print("Timeout reached waiting for " .. item.name)
            return false
        end

        for _, v in pairs(self:inventory()) do
            if v.name == item.name then
                print(item.name .. " is now stocked in inventory.")
                return true
            end
        end

        if math.floor(timer.elapsedTime) % 5 == 0 then  
            shell.run("clear")
            print("Waiting for " .. item.name .. " in inventory...")
        end
        sleep(1)
    end
end