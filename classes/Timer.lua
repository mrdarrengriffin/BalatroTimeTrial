Timer = {
    Duration = 5, -- Duration of the timer in seconds
    TimeLeft = 5,
    Thread = nil,
    Channel = nil,
    StopCallback = function()
    end,
    TickPastCallback = function()
    end
}

Timer.TickThread = [[
    require "love.timer"
    
    local channel, timeLeft = ...

    while true do
        channel:pop()
        if channel:pop() == "stop" then
            break
        end

        timeLeft = timeLeft - 1
        channel:push(timeLeft)
        love.timer.sleep(1) -- Sleep for 1 second
    end
]]

function Timer.start()
    if Timer.Thread == nil then
        Timer.Thread = love.thread.newThread(Timer.TickThread);
        Timer.Channel = love.thread.newChannel();
        Timer.Thread:start(Timer.Channel, Timer.Duration);
    end
end

function Timer.stop()
    if Timer.Thread ~= nil then
        Timer.Channel:push("stop")
        Timer.Thread = nil
        Timer.Channel = nil
    end
end

function Game:update(dt)
    local ret = game_update_ref(self, dt)

    if Timer.Thread ~= nil then
        local message = Timer.Channel:pop()
        if message then
            if type(message) == "number" then
                Timer.TimeLeft = message
                if message < 0 then
                    Timer.TickPastCallback()
                end
            end
        end
    end

    return ret
end

return Timer;
