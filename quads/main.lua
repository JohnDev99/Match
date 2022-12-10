function love.load()
    push = require 'push'
    love.graphics.setDefaultFilter('nearest', 'nearest')

    texture = love.graphics.newImage('match3.png')

    push:setupScreen(512, 288, 1280, 720, {
        fullscreen = false
    })

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:start()
    --Desenhar imagem em todo o ecra
    love.graphics.draw(texture)
    push:finish()
end