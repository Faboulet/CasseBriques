PauseMenu = Class{}

function PauseMenu:init()  -- The constructor
  
	-- print("Module / création d'une instance de PauseMenu")
  self.x = 250
  self.y = 180
  
  self.title = {}
  self.title.text = "PAUSE MENU"
  self.title.x = 305
  self.title.y = 190

  self.pauseMenus = {}
  self.nbPauseMenu = 3
  self.pauseMenus[0] = self:initButton("BACK TO GAME", 325, 230, 340, 250)
  self.pauseMenus[1] = self:initButton("SAVE GAME", 325, 285, 355, 305)
  self.pauseMenus[2] = self:initButton("BACK TO MENU", 325, 340, 340, 360)
  
  self.pauseMenuSelected = 0
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
end

function PauseMenu:initButton(_text, _x, _y, _labelX, _labelY)
  local button = {}
  button.x = _x
  button.y = _y
  button.label = {}
  button.label.x = _labelX
  button.label.y = _labelY
  button.label.text = _text
  return button
end

function PauseMenu:selectPauseMenu(number)
  self.pauseMenuSelected = number
end

function PauseMenu:drawButtons()
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
    love.graphics.setFont(listFonts['minecraft'].small)
    love.graphics.print(self.pauseMenus[i].label.text, self.pauseMenus[i].label.x, self.pauseMenus[i].label.y)
    love.graphics.reset()
  end
end

function PauseMenu:drawPauseMenu()
    -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.small, self.x, self.y)
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  self:drawButtons()
end