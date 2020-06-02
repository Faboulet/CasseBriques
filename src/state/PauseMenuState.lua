PauseMenuState = {}

function PauseMenuState:init()  -- The constructor

	-- print("Module / création d'une instance de PauseMenu")
  self.x = 150
  self.y = 200
  self.image = BACKGROUND_IMAGE.small
  
  self.title = {}
  self.title.text = "PAUSE MENU"
  self.title.x = 180
  self.title.y = 250

  self.pauseMenus = {}
  self.nbPauseMenu = 3
  self.pauseMenus[0] = self:initButton("RETURN TO GAME", 200, 180, 220, 190)
  self.pauseMenus[1] = self:initButton("SAVE GAME", 200, 250, 220, 260)
  self.pauseMenus[2] = self:initButton("RETURN TO MENU", 200, 320, 220, 190)
  
  self.pauseMenuSelected = 0
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self.saveMessage = {}
  self.saveMessage.x = 150
  self.saveMessage.y = 300
  self.saveMessage.text = ""
  self.saveMessage.font = listFonts['minecraft'].normal

  self.jeu = {}
  self.player = {}
  self.vaisseau = {}
  self.balle = {}
  self.briques = {}
end

function PauseMenuState:initButton(_text, _x, _y, _labelX, _labelY)
  local button = {}
  button.x = _x
  button.y = _y
  button.label = {}
  button.label.x = _labelX
  button.label.y = _labelY
  button.label.text = _text
  return button
end

function PauseMenuState:enter(_, _jeu, _player, _vaisseau, _balle, _briques)
  self.jeu = _jeu
  self.player = _player
  self.vaisseau = _vaisseau
  self.balle = _balle
  self.briques = _briques
end

--[[function PauseMenuState:selectPauseMenu(number)
  self.pauseMenuSelected = number
end]]



--[[function PauseMenuState:afficheSelected()
  
  if self.pauseMenuSelected == 2 then
    love.graphics.draw(imgPauseMenuReturnMenu, largeurEcran * 0.35, hauteurEcran * 0.25)
  elseif self.pauseMenuSelected == 1 then
    love.graphics.draw(imgPauseMenuSaveGame, largeurEcran * 0.35, hauteurEcran * 0.25)
  else 
    love.graphics.draw(imgPauseMenuReturnGame, largeurEcran * 0.35, hauteurEcran * 0.25)
  end
end]]

function PauseMenuState:selectPauseMenu(number)
  self.pauseMenuSelected = number
end

function PauseMenuState:enterPauseMenu()
  
  if self.pauseMenuSelected == 2 then
    Gamestate.switch(MainMenuState)
  elseif self.pauseMenuSelected == 1 then
    -- Sauvegarder la partie
    self:saveGame()
  else
    Gamestate.pop(self.optionSelected)
  end
end

function PauseMenuState:update(dt)
  self.tempsAffichageMessage = self.tempsAffichageMessage - dt
  if self.tempsAffichageMessage <= 0 then
    self.affichageMessage = not self.affichageMessage
    self.tempsAffichageMessage = 1
  end
end

function PauseMenuState:drawButtons()
  local i
  for i = 0, self.nbPauseMenu - 1 do
    if i == self.pauseMenuSelected and self.affichageMessage then
      love.graphics.draw(listImages['button'].smallSelected, self.pauseMenus[i].x, self.pauseMenus[i].y)
      --love.graphics.setColor(112, 112, 33) -- on met la couleur jaune si sélectionnée
      love.graphics.setColor(196, 196, 0) -- on met la couleur jaune si sélectionnée
    else
      love.graphics.draw(listImages['button'].small, self.pauseMenus[i].x, self.pauseMenus[i].y)
      love.graphics.setColor(1, 1, 1) -- on met la couleur blanche
    end
    love.graphics.setFont(listFonts['minecraft'].normal)
    love.graphics.print(self.pauseMenus[i].label.text, self.pauseMenus[i].label.x, self.pauseMenus[i].label.y)
    love.graphics.reset()
  end
end

function PauseMenuState:draw()
    -- dessiner le background
  love.graphics.draw(self.image, self.x, self.y)
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  self:drawButtons()
  
  if string.len(self.saveMessage.text) > 0 then
    self:afficheSaveMessage()
  end
end

function PauseMenuState:afficheSaveMessage()
  love.graphics.setColor(1, 0, 0) -- on met la couleur en rouge
  love.graphics.setFont(self.saveMessage.font)
  love.graphics.print(self.saveMessage.text, self.saveMessage.x, self.saveMessage.y)
  love.graphics.reset()
end

function PauseMenuState:saveGame()
  local save = {
    jeu = {
      currentLevel = self.currentLevel,
      difficulty = self.difficulty,
      nbBriquesIncassables = self.nbBriquesIncassables,
      timeElapsed = self.timeElapsed,
      totalTimeElapsed = self.totalTimeElapsed
    },
    player=self.player,
    vaisseau={
      x = vaisseau.x,
      y = vaisseau.y,
      v = vaisseau.v
    },
    balle=self.balle,
    briques=self.briques
  }
  local success, errorString = persistence.persistSave(save)
  if not success then 
    self.saveMessage = "Following error occured with save file"..errorString
  else
    self.saveMessage = "Save OK"
  end
end

function PauseMenuState:keypressed(key)
  
  self.saveMessage.text = ""
  if key == "up" then
    self:selectPauseMenu((self.pauseMenuSelected - 1) % self.nbPauseMenu)
  end
  if key == "down" then
    self:selectPauseMenu((self.pauseMenuSelected + 1) % self.nbPauseMenu)
  end
  if key == "return" then
    self:enterPauseMenu()
  end
end