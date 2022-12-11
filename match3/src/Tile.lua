Tile = Class{}

function Tile:init(x, y, color, variety)
    self.gridX = x
    self.gridY = y

    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    self.color = color
    self.variety = variety
end

function Tile:render(x, y)
    --Desenhar uma sombra
    love.graphics.setColor(34, 32, 52, 255)
    love.graphics.draw(gTextures['match3'], gFrames['tiles'][self.color][self.variety], 
    self.x + x + 2, self.y + y + 2)--offset da sombra do tile

    --Desenhar o tile
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['match3'], gFrames['tiles'][self.color][self.variety], 
    self.x + x, self.y + y)
end