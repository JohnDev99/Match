BeginGameState = Class{_includes = BaseState}

function BeginGameState:init()
    --Transiçao (fade in)
    self.transitionAlpha = 1
    --Criar quadro de tiles
    self.board = Board(VIRTUAL_WIDTH - 272, 16)
    --Iniciar quadro fora do ecra
    self.labelLevelY = -64
end

function BeginGameState:enter(def)
    self.level = def.level
    Timer.tween(1, {
        --Transiçao de ecra de Inicio de Jogo
        [self] = {transitionAlpha = 0}
    })
    :finish(function()
        Timer.tween(0.25, {
            [self] = {labelLevelY = VIRTUAL_HEIGHT / 2 - 8}
        })
        finish(function()
            Timer.after(1, function()
                Timer.tween(0.25, {
                    [self] = {labelLevelY = VIRTUAL_HEIGHT + 30}
                })
                finish(function()
                    gStateMachine:change('play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    self.board:render()
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.labelLevelY - 8, VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, self.labelLevelY, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
end
