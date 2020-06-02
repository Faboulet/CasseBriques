GameCompleteState = {}

function GameCompleteState:init()
  self.title = {}
  self.title.text = "CONGRATULATIONS"
  self.title.x = 70
  self.title.y = -250
  
  self.content = {}
  self.content.text = "YOU JUST BROKE THE GAME"
  self.content.x = 25
  self.content.y = -150
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self.jeu = {}
  self.player = {}
  
  self:initDraw()
end

function GameCompleteState:initDraw()
  flux.to(self.title, 3, { y = 90 })
      :ease("backout")
  flux.to(self.content, 3, { y = 230 })
      :ease("backout")
end

function GameCompleteState:enter(_, _jeu, _player)
  self.jeu = _jeu
  self.player = _player
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function GameCompleteState:update(dt)
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

function GameCompleteState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function GameCompleteState:draw()
    -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setColor(1, 1, 1) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].biggest)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  love.graphics.setFont(listFonts['minecraft'].bigger)
  love.graphics.print(self.content.text, self.content.x, self.content.y)
  
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
end

function GameCompleteState:keypressed(key)
  if next(flux.tweens) == nil and key == "return" then
    Gamestate.switch(HighScoreState, self.jeu, self.player)
  end
end