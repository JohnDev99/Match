push = require 'push'
Timer = require 'Knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()

    intervals = {1, 2, 4, 3, 2, 8}
    counters = {0, 0, 0, 0, 0, 0}

    for i = 1, 6 do
        --Funçao anonima
        Timer.every(intervals[i], function()
            counters[i] = counters[1] + 1
        end)
    end


    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        resizable = true,
        vsync = true,
        fullscreen = false
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    --Timer
    Timer.update(dt)
end

function love.draw()
    push:start()

    for i = 1, 6 do

        love.graphics.printf('Timer ' .. tostring(counters[i]) .. ' seconds(every ' .. tostring(intervals[i]) .. ')',
         0, 54 + i * 16, VIRTUAL_WIDTH, 'center')
    end

    push:finish()
end