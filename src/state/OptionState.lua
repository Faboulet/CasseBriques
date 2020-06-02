OptionState = {}

function OptionState:init()  -- The constructor

	--print("Module / création d'une instance de Option")
  self.x = 0
  self.y = 0
  
  self.title = {}
  self.title.text = "OPTIONS"
  self.title.x = 220
  self.title.y = -250
  
  self.content = {}
  self.content.text = "CHOOSE DIFFICULTY"
  self.content.font = listFonts['minecraft'].bigger
  self.content.x = 130
  self.content.y = -50
  
  self.listeOptions = {}
  self.nbOptions = 3
  self.optionSelected = 1 -- 1 correspond à Medium, 0 à Easy et 2 à difficult
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self:initDraw()
end

function OptionState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
  flux.to(self.content, 3, { y = 170 })
      :ease("backout")
  self.listeOptions[0] = self:initButton("EASY", 50, -50, 95, -35)
  flux.to(self.listeOptions[0], 2, { y = 280 })
      :ease("elasticout")
  flux.to(self.listeOptions[0].label, 2, { y = 295 })
      :ease("elasticout")
  self.listeOptions[1] = self:initButton("NORMAL", 320, -50, 345, -35)
  flux.to(self.listeOptions[1], 2, { y = 280 })
      :ease("elasticout")
  flux.to(self.listeOptions[1].label, 2, { y = 295 })
      :ease("elasticout")
  self.listeOptions[2] = self:initButton("DIFFICULT", 590, -50, 600, -35)
  flux.to(self.listeOptions[2], 2, { y = 280 })
      :ease("elasticout")
  flux.to(self.listeOptions[2].label, 2, { y = 295 })
      :ease("elasticout")
end

function OptionState:initButton(_text, _x, _y, _labelX, _labelY)
  local button = {}
  button.x = _x
  button.y = _y
  button.label = {}
  button.label.x = _labelX
  button.label.y = _labelY
  button.label.text = _text
  return button
end

function OptionState:enter()
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function OptionState:selectOption(number)
  self.optionSelected = number
end

function OptionState:update(dt)
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

function OptionState:drawButtons()
  local i
  for i = 0, self.nbOptions - 1 do
    if i == self.optionSelected and self.affichageMessage then
      love.graphics.draw(listImages['button'].optionSelect, self.listeOptions[i].x, self.listeOptions[i].y)
      love.graphics.setColor(196, 196, 0) -- on met la couleur jaune si sélectionnée
    else
      love.graphics.draw(listImages['button'].option, self.listeOptions[i].x, self.listeOptions[i].y)
      love.graphics.setColor(1, 1, 1) -- on met la couleur blanche
    end
    love.graphics.setFont(listFonts['minecraft'].big)
    love.graphics.print(self.listeOptions[i].label.text, self.listeOptions[i].label.x, self.listeOptions[i].label.y)
    love.graphics.reset()
  end
end

function OptionState:draw()
  
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, self.x, self.y)
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  love.graphics.setFont(self.content.font)
  love.graphics.print(self.content.text, self.content.x, self.content.y)
  
  self:drawButtons()
  love.graphics.reset()
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
end

function OptionState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function OptionState:keypressed(key)
  if next(flux.tweens) == nil then
    if key == "left" then
      self:selectOption((self.optionSelected - 1) % self.nbOptions)
    end
    if key == "right" then
      self:selectOption((self.optionSelected + 1) % self.nbOptions)
    end
    if key == "return" then
      Gamestate.pop(self.optionSelected)
    end
  end
end