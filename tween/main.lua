push = require 'push'
Timer = require 'Knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TIMER_MAX = 10

function love.load()


    flappy = love.graphics.newImage('flappy.png')
    --Tabela de Birds
    birds = {}

    for i = 1, 1000 do
        table.insert(birds, {
            x = 0,
            --Posiçao aleatorea no y
            y = math.random(VIRTUAL_HEIGHT - 24),
            --Gerar um numero entre 0 e .99 + numero aleatoreo entre 10 - 1 = 10.99 ou outro flotoante
            rate = math.random() + math.random(TIMER_MAX - 1),
            opacity = 0
        })
    end

    --Posiçao final
    endX = VIRTUAL_WIDTH - flappy:getWidth()
    for k, bird in pairs(birds) do
        Timer.tween(bird.rate, {
            [bird] = {x = endX, opacity = 255}
        })
    end


    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    Timer.update(dt)
end

function love.draw()
    push:start()

    for k, bird in pairs(birds) do 
        love.graphics.setColor(255, 255, 255, bird.opacity)
        love.graphics.draw(flappy, bird.x, bird.y)

    end
    push:finish()
end