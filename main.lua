require 'src/parameters/dependencies'

function love.load()
    require 'src/parameters/init'
end

function love.update(dt)
    --love.keyboard.lastKeyPressed=nil
end

function love.draw() 
    -- displayFPS()
end

function love.keypressed(key)
    --love.keyboard.lastKeyPressed=key
end