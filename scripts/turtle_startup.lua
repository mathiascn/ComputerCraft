--- Startup Script
-- This script initializes a TurtleBot instance and sets its status to idle.
-- The TurtleBot then updates its data on the server to reflect its current status and position.

dofile("turtle_bot")

local scriptName = "startup"

-- Create a new TurtleBot instance, facing North.
local t = TurtleBot.new(scriptName, "North")

-- Connect the TurtleBot to the server API.
t:connect()

-- Set the TurtleBot's status to idle.
t.status = STATUS.IDLE

-- Update the TurtleBot's data on the server to reflect its current status.
t:updateData()