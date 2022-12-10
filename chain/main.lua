push = require 'push'

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
    birdX, birdY = 0, 0
    baseX, baseY = birdX, birdY

    timer = 0

    --coordenadas dos meus destinos
    destinations = {
        --Mover para a direita
        [1] = {x = VIRTUAL_WIDTH - birdSprite:getWidth(), y = 0},
        --Mover para baixo
        [2] = {x = VIRTUAL_WIDTH - birdSprite:getWidth(), y = VIRTUAL_HEIGHT - birdSprite:getHeight()},
        --Mover para a esquerda
        [3] = {x = 0, y = VIRTUAL_HEIGHT - birdSprite:getHeight()},
        --Mover para a posiçao inicial(topo esquerdo)
        [4] = {x = 0, y = 0}
    }

    for k, destination in pairs(destinations) do 
        destination.reached = false
    end

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,{
        fullscreen = false,
        vsyn = true,
        resizable = true
    })

    function love.resize(w, h)
        push:resize(w, h)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    --
    timer = math.min(MOVEMENT_TIME, timer + dt)

    --ipairs para matrizes
    for i, destination in ipairs(destinations) do
        if not destination.reached then
            --interpolaçao linear entre posiçoes
            birdX, birdY = baseX + (destination.x - baseX) * timer / MOVEMENT_TIME,
            baseY + (destination.y - baseY) * timer / MOVEMENT_TIME

            --Se o contador chegar a 2s
            if timer == MOVEMENT_TIME then
                destination.reached = true --cheguei ao me destino
                baseX, baseY = destination.x, destination.y --Posiçao atual
                timer = 0 --reniciar contador
            end
            --So precisa de calcular o primeiro destination.reached
            break
        end
    end
end
   
function love.draw()
    push:start()
    love.graphics.draw(birdSprite, birdX, birdY)
    push:finish()
end