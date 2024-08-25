--- Timer Class
-- The Timer class provides functionality to track elapsed time in ticks within the Minecraft environment. 
-- It can start, stop, and reset a timer, and calculate the total elapsed time across multiple days.

Timer = {}
Timer.__index = Timer

--- Creates a new Timer instance.
-- Initializes a new Timer object and resets its state.
-- @return A new Timer object.
function Timer.new()
    local self = setmetatable({}, Timer)
    self:reset()
    return self
end


--- Starts the timer.
-- Records the current in-game time and day when the timer is started.
function Timer:start()
    self.startTime = os.time()
    self.startDay = os.day()
    self.endTime = nil
    self.endDay = nil
end


--- Stops the timer.
-- Records the current in-game time and day when the timer is stopped.
-- Calculates the elapsed time in ticks, accounting for time across multiple days if necessary.
function Timer:stop()
    local tick = 0.2     -- Time increment per tick
    local fullDay = 24.0 -- Full days in ticks
    self.endTime = os.time()
    self.endDay = os.day()
    self.elapsedDay = self.endDay - self.startDay

    if self.elapsedDay == 0 then
        self.elapsedTime = (self.endTime - self.startTime) / tick
    else
        local timeToMidnight = (24.0 - self.startTime) / tick  -- Time from start to 00:00 of the next day
        local timeFromMidnight = self.endTime / tick           -- Time from 00:00 to end time
        local fullDaysTicks = (self.elapsedDay - 1) * fullDay
        self.elapsedTime = timeToMidnight + timeFromMidnight + (fullDaysTicks / tick)
    
    end
end


--- Resets the timer.
-- Clears the start and end times, resetting the timer to its initial state.
function Timer:reset()
    self.startTime = nil
    self.startDay = nil
    self.endTime = nil
    self.endDay = nil
    self.elapsedDay = nil
    self.elapsedTime = nil
end