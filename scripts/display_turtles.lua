--- Turtle Monitoring Script
-- This script monitors and displays information about turtles on a connected monitor.
-- It retrieves data from an API and updates the monitor at regular intervals, displaying each turtle's ID, label, coordinates, current script, status, and fuel level.

-- Retrieve command-line arguments.
local args = {...}
local scriptName = "display_turtles"

-- Check if the required argument (refresh rate) is provided.
if #args < 1 then
    print("Usage: " .. scriptName .. " <refresh rate>")
    return
end

--- Print turtle data on the monitor.
-- Displays information about a single turtle, including its ID, label, coordinates, current script, status, and fuel level.
-- The function adjusts text and background colors based on the turtle's status.
-- @param monitor The monitor peripheral to display the information on.
-- @param turtle A table containing the turtle's data, including id, label, coordinates, current script, status, and fuel level.
local function printTurtleData(monitor, turtle)
    local x, y = monitor.getCursorPos()

    monitor.setTextColor(colors.white)
    monitor.write("#" .. turtle.id .. " ")
    x = x + 5
    
    monitor.setCursorPos(x, y)
    monitor.setTextColor(colors.yellow)
    monitor.write(turtle.label)
    x = x + 11
    
    monitor.setCursorPos(x, y)
    monitor.setTextColor(colors.white)
    monitor.write(" (" .. turtle.coordinate_x .. "," .. turtle.coordinate_y .. "," .. turtle.coordinate_z .. ") ")
    x = x + 20

    monitor.setCursorPos(x, y)
    monitor.setTextColor(colors.lightBlue)
    monitor.write(turtle.current_script .. " ")
    x = x + 11

    monitor.setCursorPos(x, y)
    if turtle.status == "Error" then
        monitor.setBackgroundColor(colors.red)
    elseif turtle.status == "Running" then
        monitor.setBackgroundColor(colors.green)
    elseif turtle.status == "Idle" then
        monitor.setBackgroundColor(colors.orange)
    else
        monitor.setBackgroundColor(colors.lightBlue)
    end
    monitor.setTextColor(colors.white)
    monitor.write(turtle.status)
    monitor.setBackgroundColor(colors.black)
    x = x + 8

    monitor.setCursorPos(x, y)
    monitor.write(" Fuel: " .. turtle.fuel_lvl)
    
    monitor.setCursorPos(1, y + 1)
end


--- Find and return the monitor peripheral.
-- Attempts to find a connected monitor peripheral. If no monitor is found, an error is raised.
-- @return The monitor peripheral.
local function getMonitor()
    local monitor = peripheral.find("monitor")
    if not monitor then
        error("No monitor found", 2)
    end
    return monitor
end


--- Load and return the API client.
-- Loads the API client from the file system and initializes it with the base URL retrieved from the environment variables.
-- If the API client cannot be loaded, an error is raised.
-- @return The initialized API client.
local function getApiClient()
    local ENV = loadEnv()
    local apiClient = loadfile("api_client")()
    if not apiClient then
        error("Failed to load API client", 2)
    end
    return apiClient.new(ENV.API)
end


--- Refresh the monitor display with turtle data.
-- Continuously retrieves turtle data from the API and updates the connected monitor with this information.
-- The monitor is cleared and updated at intervals specified by the refresh rate.
-- @param refresh_rate The time in seconds between each refresh of the monitor display.
local function main(refresh_rate)
    local client = getApiClient()
    local monitor = getMonitor()
    while true do
        -- Retrieve turtle data from the API
        local turtles = client:get("/turtles")
        
        -- Clear and prepare the monitor for new data
        monitor.setBackgroundColor(colors.black)
        monitor.clear()
        monitor.setTextScale(0.9)
        
        -- Display header
        monitor.setCursorPos(1, 1)
        monitor.write("Turtle Information:")
        
        -- Display data for each turtle
        monitor.setCursorPos(1, 3)
        for _, turtle in ipairs(turtles) do
            printTurtleData(monitor, turtle)
        end

        -- Wait for the specified refresh rate before updating again
        sleep(refresh_rate)
    end
end


main(tonumber(args[1]))