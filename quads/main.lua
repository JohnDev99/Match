function GenerateQuads(texture, width, height)
    local sheetWidth = texture:getWidth() / width
    local sheetHeight = texture:getHeight() / height

    local quadCounter = 1
    local quads = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            --Gerar um quad e armazena-lo na tabela por ordem
            quads[quadCounter] = love.graphics.newQuad(x * width, y * height, width, height, texture:getDimensions())
            quadCounter = quadCounter + 1
        end
    end
    return quads
end

function love.load()
    push = require 'push'
    love.graphics.setDefaultFilter('nearest', 'nearest')

    texture = love.graphics.newImage('match3.png')

    --quad = love.graphics.newQuad(0, 0, 32, 32, texture:getDimensions())
    quads = GenerateQuads(texture, 32, 32)
    --Escolher um quad aleatorio da minha tabela
    --randomQuad = quads[math.random(#quads)]

    --Gerar uma tela de quads fixos
    refreshTiles()

    push:setupScreen(512, 288, 1280, 720, {
        fullscreen = false
    })

end

function refreshTiles()
    --Desenhar uma tabela de quads aleatorios

    tiles = {}
    --Cada tile da linha vai receber uma tabela vazia
    for y = 1, 288 / 32 do
        table.insert(tiles, {})
        --Preencher a tabela vazia de cada tile da coluna com um quad
        for x = 1, 512 / 32 do
            table.insert(tiles[y], math.random(#quads))
        end
    end
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    --Desenhar imagem em todo o ecra
    --love.graphics.draw(texture, quads[math.random(#quads)])

    --Desenhar todos os quads
    --Começo do 0 ATE 288 DE 32 a 32(linhas)
    for y = 1, 288 / 32 do
        --Começo do 0 até 512 de 32 a 32(colunas)
        for x = 1, 512 / 32 do
            --Desenhar em cada posiçao da matriz um quad que foi gerado
            love.graphics.draw(texture, quads[tiles[y][x]], (x - 1) * 32, (y - 1) * 32)
        end
    end
    push:finish()
end