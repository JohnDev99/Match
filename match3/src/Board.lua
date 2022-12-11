Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y 
    --Tabela de conjuntos
    self.matches = {}
    --Metodo de inicializaçao de tiles
    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}
    
    for tileY = 1, 8 do
        --Matriz (linhas e colunas)
        table.insert(self.tiles, {})
        for tileX = 1, 8 do
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(18), math.random(6)))
        end
    end

    --Progamaçao recursiva
    while self.calculatesMatches() do
        self:initializeTiles()
    end
end

function Board:calculatesMatches()
    local matches = {}

    local matchNum = 1

    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color
        matchNum = 1
        for x = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color
                if matchNum >= 3 then
                    local match = {}
                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end
                    table.insert(matches, match)
                end
                    matchNum = 1
                if x >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            for x = 8, 8 - matchNum + 1, -1 do
                table.insert(matches, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end
    --Conjuntos verticais

    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color
        matchNum = 1

        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end
                    table.insert(matches, match)
                end
                matchNum = 1

                if y >= 7 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}
            for y = 8, 8 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end

    self.matches = matches
    return #self.matches > 0 and self.matches or false
end

--Remover os conjuntos de blocos listados
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end
    self.matches = nil
end

--Efeito visual de blocos ocuparem os espaços removidos
function Board:getFallingTiles()
    local tweens = {}
    for x = 1, 8 do
        local space = false
        local spaceY = 0
        local y = 8
        while y >= 1 do
            local tile = self.tiles[y][x]
            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY
                    self.tiles[y][x] = nil
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }
                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                if spaceY == y then
                    spaceY = 0
                end
            end
            y = y - 1
        end
    end
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]
            --Se a posiçao for nula
            if not tile then
                --Criar novo tile aleatorio
                local tile = Tile(x, y, math.random(18), math.random(6))
                tile.y = -32
                self.tiles[y][x] = tile
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end
    return tweens
end

function Board:render()
    --Para todos os elementos da minha tabela(#)
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end