GameOverState = {}

function GameOverState:init()
  self.x = 0
  self.y = 0
  
  self.title = {}
  self.title.text = "GAME OVER"
  self.title.x = 165
  self.title.y = -250
  
  self.jeu = {}
  self.player = {}
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self:initDraw()
end

function GameOverState:initDraw()
  flux.to(self.title, 3, { y = 200 })
      :ease("backout")
end

function GameOverState:enter(_, _jeu, _player)
  self.jeu = _jeu
  self.player = _player
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function GameOverState:update(dt)
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

function GameOverState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
end

function GameOverState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function GameOverState:keypressed(key)
  if next(flux.tweens) == nil and key == "return" then
    Gamestate.switch(HighScoreState, self.jeu, self.player)
  end
end