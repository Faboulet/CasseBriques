math.randomseed(love.timer.getTime())

love.window.setTitle(TITLE)
love.window.setMode(ECRAN_LARGEUR, ECRAN_HAUTEUR) -- dimensions de la fenêtre
-- love.graphics.setFont(gFonts.small)
love.graphics.setDefaultFilter('nearest','nearest')
--listStateMachine:change('intro')
Gamestate.registerEvents()
Gamestate.switch(IntroState)

listSounds['music']:setVolume(0.4)
listSounds['music']:play()
listSounds['music']:setLooping(true)