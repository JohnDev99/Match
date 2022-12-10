push = require 'push'

-- for GenerateQuads
require 'Util'

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    texture = love.graphics.newImage('match3.png')

    --quad = love.graphics.newQuad(0, 0, 32, 32, texture:getDimensions())
    quads = GenerateQuads(texture, 32, 32)

    board = generateBoard()

    --Selecionar um tile e trocar posiçoes com outro
    highlitedTile = false
    highlitedX, highlitedY = 1, 1
    --Começar com o primeiro tile selecionado
    selectedTile = board[1][1]


    push:setupScreen(512, 288, 1280, 720, {
        fullscreen = false
    })

end
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    local x, y = selectedTile.gridX, selectedTile.gridY
    if key == 'up' then
        --Mover para cima
        if y > 1 then
            selectedTile = board[y - 1][x]
        end
    elseif key == 'down' then
        --Mover para baixo
        if y < 8 then
            selectedTile = board[y + 1][x]
        end
    elseif key == 'left' then
        if x > 1 then
            selectedTile = board[y][x - 1]
        end
    elseif key == 'right' then
        if x < 8 then
            selectedTile = board[y][x + 1]
        end
    end

    --Selecionar tile se nao for um ja selecionado
    if key == 'enter' or key == 'return' then
        if not highlitedTile then
            highlitedTile = true
            highlitedX, highlitedY = selectedTile.gridX, selectedTile.gridY
        else
            --Caso seja um selecionado vou trocar posiçoes
            --Tile selecionado
            local tile1 = selectedTile
            --Tile a trocar de posiçao com o selecionado
            local tile2 = board[highlitedY][highlitedX]

            --Criar variaveis temporarias que vao guardar essa informaçao
            --Troca de dados num array (CS50)
            local tempX, tempY = tile2.x, tile2.y
            local tempGridX, tempGridY = tile2.gridX, tile2.gridY

            --Trocar posiçoes no array/matriz
            local tempTile = tile1
            board[tile1.gridY][tile1.gridX] = tile2
            board[tile2.gridY][tile2.gridX] = tempTile

            --Trocar coordenadas dos 2 tiles
            tile2.x, tile2.y = tile1.x, tile1.y
            tile2.gridX, tile2.gridY = tile1.gridX, tile1.gridY
            tile1.x, tile1.y = tempX, tempY
            tile1.gridX, tile1.gridY = tempGridX, tempGridY

            --Desselecionar o tile escolhido
            highlitedTile = false
            --Selecionar no tile trocado
            selectedTile = tile2
        end
    end
end

function love.draw()
    push:start()

    --Argumentos para desenhar o quadro centrado no meio do ecra e nao em toda a sua extensao
    drawBoard(128, 16)

    push:finish()
end

function generateBoard()
    local tiles = {}

    for y = 1, 8 do
        table.insert(tiles, {})
        for x = 1, 8 do
            --Inserir no y da tabela vazia 
            table.insert(tiles[y], {
                --coordenadas do tile
                x = (x - 1) * 32, y = (y - 1) * 32,
                gridX = x, gridY = y,
                tile = math.random(#quads)
            })
        end
    end

    return tiles
end

function drawBoard(offsetX, offsetY)
    --Metodo Para desenhar cada tile da minha matriz na sua posiçao ja defenida na tabela
    for y = 1, 8 do
        for x = 1, 8 do
            local tile = board[y][x]
            love.graphics.draw(texture, quads[tile.tile], tile.x + offsetX, tile.y + offsetY)

            --Desenhar a seleçao
            if highlitedTile then
                if tile.gridX == highlitedX and tile.gridY == highlitedY then
                    --Desengar retangulo de seleçao(opacidade)
                    love.graphics.setColor(1, 1, 1, 128/255)
                    love.graphics.rectangle('fill', tile.x + offsetX, tile.y + offsetY, 32, 32, 4)
                    love.graphics.setColor(1, 1, 1, 1)
                end
            end
        end
    end

    --Desenhar contorno da seleçao
    love.graphics.setColor(1, 0, 0, 234/255)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', selectedTile.x + offsetX, selectedTile.y + offsetY, 32, 32, 4)
    

end