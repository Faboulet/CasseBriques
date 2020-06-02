CommandState = {}

function CommandState:init()
  
  self.title = {}
  self.title.text = "COMMANDS"
  self.title.x = 165
  self.title.y = -250
  
  self.content = {}
  self.content.image = listImages['menu'].commands
  self.content.x = 80
  self.content.y = -500
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self:initDraw()
end

function CommandState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
  flux.to(self.content, 3, { y = 150 })
      :ease("backout")
end

function CommandState:enter()
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function CommandState:leave()
  
end

function CommandState:update(dt)
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

function CommandState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function CommandState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  love.graphics.draw(self.content.image, self.content.x, self.content.y)
  
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
end

function CommandState:keypressed(key)
  if next(flux.tweens) == nil and key == "return" then
    Gamestate.switch(MainMenuState)
  end
end