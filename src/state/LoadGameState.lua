LoadGameState = {}

function LoadGameState:init()
  
  self.title = {}
  self.title.x = 160
  self.title.y = -250
  self.title.text = "LOAD GAME"
  
  self.image = {}
  self.image.address = listImages['menu'].loadGame
  self.image.x = 65
  self.image.y = 250
  self.saveToLoad = false
  
  self.message = {}
  self.message.text = ""
  self.message.font = listFonts['minecraft'].big
  self.save = {}
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self:initDraw()
end

function LoadGameState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
end

function LoadGameState:enter()
  BACKGROUND_IMAGE = listImages['BG'][1]
  self:loadGame()
end

function LoadGameState:leave()
  
end

function LoadGameState:update(dt)
  if next(flux.tweens) ~= nil then
    flux.update(dt)
  else
    self.tempsAffichageMessage = self.tempsAffichageMessage - dt
    if self.tempsAffichageMessage <= 0 then
      self.affichageMessage = not self.affichageMessage
      self.tempsAffichageMessage = 1
    end
  end
end

function LoadGameState:loadGame() 
  local resultatSave = persistence.fetchSave()
  -- No Save was stored
  if resultatSave ~= nil then
    -- Initialize the Save with the value read from the JSON decoded table
    self.save = resultatSave
    self.saveToLoad = true
    self.message.text = "A save has been succesfully loaded"
  else
    self.message.text = "Problem with save or no save found"
  end
end

function LoadGameState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function LoadGameState:draw()
    -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  love.graphics.draw(self.image.address, self.image.x, self.image.y)
  
  -- dessiner le message
  love.graphics.setColor(1, 1, 1) -- on met la couleur en blanc
  love.graphics.setFont(self.message.font)
  love.graphics.print(string.upper(self.message.text), 80, 180)
  
  love.graphics.setFont(listFonts['orbitron'].normal)
  if next(self.save) ~= nil then
    love.graphics.print(string.upper(self.save.jeu.currentLevel), 110, 310)
    love.graphics.print(self.save.player.vies, 190, 310)
    local diff = ""
    if self.save.jeu.difficulty == 0 then diff = "EASY"
    elseif self.save.jeu.difficulty == 1 then diff = "NORMAL"
    else diff = "DIFFICULT"
    end
    love.graphics.print(diff, 250, 310)
    love.graphics.print(self.save.player.name, 355, 310)
    love.graphics.print(self.save.player.score, 490, 310)
    love.graphics.print(formatTime(self.save.jeu.totalTimeElapsed), 620, 310)
  end
  
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
  
end

function LoadGameState:keypressed(key)
  if next(flux.tweens) == nil then
    if key == "return" and self.saveToLoad then
      Gamestate.switch(NextLevelState, true, self.save)
    else
      Gamestate.switch(MainMenuState)
    end
  end
end