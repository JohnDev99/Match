push = require 'push'
Timer = require 'Knife.timer'

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT= 720

--Cada Movimento vai durar 2 segundos
MOVEMENT_TIME = 2


--Mover um objeto ao longo do tempo

function love.load()
    --Carregar sprite
    birdSprite = love.graphics.newImage('flappy.png')
    --Criar duas variaveis na mesma linha
    bird = {x = 0, y = 0}

    --Tween --
    --Apos cada interpolaçao encerrar passar para a proxima(IEnumerator)
    Timer.tween(MOVEMENT_TIME, {
        [bird] = {x = VIRTUAL_WIDTH - birdSprite:getWidth(), y = 0}
    })
    :finish(function()
        Timer.tween(MOVEMENT_TIME, {
        [bird] = {x = VIRTUAL_WIDTH - birdSprite:getWidth(), y = VIRTUAL_HEIGHT - birdSprite:getHeight()}
        })
        :finish(function()
            Timer.tween(MOVEMENT_TIME, {
                [bird] = {x = 0, y = VIRTUAL_HEIGHT - birdSprite:getHeight()}
            })
            :finish(function()
                Timer.tween(MOVEMENT_TIME, {
                    [bird] = {x = 0, y = 0}
                })
            end)
        end)
    end)

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsyn = true,
        resizable = true
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
    --Uso do meu Tween:update
    Timer.update(dt)
end
   
function love.draw()
    push:start()
    love.graphics.draw(birdSprite, bird.x, bird.y)
    push:finish()
end