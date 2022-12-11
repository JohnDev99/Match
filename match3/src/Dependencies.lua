push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/Knife.timer'

require 'src/StateMachine'
require 'src/constants'
require 'src/Board'
require 'src/Tile'
require 'src/Util'

--Importar estados
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

--Tabela de Sons
gSounds = {
    ['clock'] = love.audio.newSource('sounds/clock.wav', 'static'),
    ['error'] = love.audio.newSource('sounds/error.wav', 'static'),
    ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
    ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
    ['music2'] = love.audio.newSource('sounds/music2.mp3', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static')
}

--Tabela de imagens
gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['match3'] = love.graphics.newImage('graphics/match3.png')
}

gFrames = {
    ['tiles'] = GenerateTileQuads(gTextures['match3'])
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
}