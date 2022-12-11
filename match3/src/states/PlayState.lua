PlayState = Class{_includes = BaseState}

function PlayState:init()
    self.transitionAlpha = 1
    --Posiçao do primeiro bloco selecionado
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    self.highlithedRect = false
    self.canInput = true

    self.highlitedTile = nil

    self.score = 0
    self.timer = 60
    
    --Cursor de seleçao pisca-pisca
    Timer.every(0.5, function()
        self.highlithedRect = not self.highlithedRect
    end)

    --Diminuir contagem
    Timer.every(1, function()
        self.timer = self.timer - 1
        --Tempo a esgotar
        if self.timer <= 5 then
            gSounds['clock']:play()
        end
    end)
end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board or Board(VIRTUAL_WIDTH - 272, 16)
    self.score = params.score or 0
    self.scoreGoal = self.level * 1.25 * 1000
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if self.timer <= 0 then
        Timer.clear()
        gSounds['game-over']:play()
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.score
        })
    end

    if self.canInput then
        if love.keyboard.wasPressed('up') then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.boardHighlightY = math.min(7, self.boardHighlightY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.boardHighlightX = math.min(7, self.boardHighlightX + 1)
            gSounds['select']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1

            if not self.highlitedTile then
                self.highlitedTile = self.board.tiles[y][x]
            elseif self.highlitedTile == self.board.tiles[y][x] then
                self.highlitedTile = nil
            
            --Caso esteja a selecionar um tile que esta a mais de 1 de distancia em x e y
            elseif math.abs(self.highlitedTile.gridX - x) + math.abs(self.highlitedTile.gridY - y) > 1 then
                gSounds['error']:play()
                self.highlitedTile = nil
            else
                --Troca de posiçoes
                local tempX = self.highlitedTile.gridX
                local tempY = self.highlitedTile.gridY

                --Copiar posiçao 
                local newTile = self.board.tiles[y][x]

                self.highlitedTile.gridX = newTile.gridX
                self.highlitedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                --Trocar de posiçoes na tabela [index]
                self.board.tiles[self.highlitedTile.gridY][self.highlitedTile.gridX] = self.highlitedTile
                self.board.tiles[newTile.gridY][newTile.gridX] = newTile

                --Transitar de posiçoes ao longo do tempo
                Timer.tween(0.1, {
                    [self.highlitedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlitedTile.x, y = self.highlitedTile.y}
                }):finish(function()
                    self:calculatesMatches()
                end)
            end
        end
    end
    Timer.update(dt)
end

function PlayState:calculatesMatches()
    self.highlitedTile = nil

    --Se gerar conjuntos, remove os e cria outros
    local matches = self.board:calculatesMatches()

    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()
        for k, match in pairs(matches) do
            self.score = self.score + #match * 50
        end
        self.board:removeMatches()

        local tilesFall = self.board:getFallingTiles()
        Timer.tween(0.25, tilesFall):finish(function()
            self:calculatesMatches()
        end)

    else
        self.canInput = true
    end
end

function PlayState:render()
    self.board:render()
    if self.highlitedTile then
        --Rectangulo é denhado mais brilhante(Mutiply Color)
        love.graphics.setBlendMode('add')
        love.graphics.setColor(1, 1, 1,96/255)
        love.graphics.rectangle('fill', (self.highlitedTile.gridX - 1) * 32 + (VIRTUAL_WIDTH - 272),
        (self.highlitedTile.gridY - 1) * 32 + 16, 32, 32, 4)
        --Voltar ao modo normal
        love.graphics.setBlendMode('alpha')
    end

    if self.highlithedRect then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(172/255, 50/255, 50/255, 1)
    end

    --Contorno
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (VIRTUAL_WIDTH - 272),
    self.boardHighlightY * 32 + 16, 32, 32, 4)

    --GUI
    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level: ' .. tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score: ' .. tostring(self.score), 20, 52, 182, 'center')
    love.graphics.printf('Goal : ' .. tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Timer: ' .. tostring(self.timer), 20, 108, 182, 'center')
end
