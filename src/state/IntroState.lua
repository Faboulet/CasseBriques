IntroState = {}

local stars = {}

function IntroState:init()
  self.text = { x = 220, y = 200, alpha = 0, str = "CASSE BRIQUE" , font = listFonts['minecraft'].bigger}
  self.signature = { x = 350, y = 260, alpha = 0, str = "BY FAB" , font = listFonts['minecraft'].big}
  self.tempsAttente = 3
  self.affichePressEnter = false
  self.tempsAffichePressEnter = 1
  self.timeToPressEnter = false
  self.pressEnterTermine = false
  self.step = 0
  
  self.vaisseau = {}
  self.vaisseau.x = ECRAN_LARGEUR / 2
  self.vaisseau.y = ECRAN_HAUTEUR + 50
  self.vaisseau.v = 15
  self.vaisseau.image = listImages['vaisseau'].intro
  self.vaisseau.l = self.vaisseau.image:getWidth()
  self.vaisseau.h = self.vaisseau.image:getHeight()
  
  self.balle = {}
  self.balle.r = 10
  self.balle.angle = -5 * math.pi / 8
  self.balle.v = 2
  self.balle.vX = math.cos(self.balle.angle) * self.balle.v
  self.balle.vY = math.sin(self.balle.angle) * self.balle.v
  self.balle.alpha = 0
  self.balle.ready = false
  self.balle.x = self.vaisseau.x
  self.balle.y = self.vaisseau.y - self.vaisseau.image:getHeight()/2 - self.balle.r
  self.balle.nbCasses = 0
  
  self.squares = {}
end

function IntroState:enter()
  local s
  for s=1, 50 do
    local star = {}
    star.x = math.random() * 800
    star.y = math.random() * 600
    star.alpha = math.random()
    star.v = math.random(5)
    table.insert(stars, star)
  end
  self:createIntro1()
end

function IntroState:afficherBalle()
  self.balle.angle = -5 * math.pi / 8
  self.balle.vX = math.cos(self.balle.angle) * self.balle.v
  self.balle.vY = math.sin(self.balle.angle) * self.balle.v
  self.balle.ready = false
  self.balle.alpha = 1
  self.balle.nbCasses = 0
  self.tempsAttente = 3
end

function IntroState:CheckCollision(_balle,_square)
  if _square.x <= _balle.x + _balle.r + _balle.v and _square.x >= _balle.x + _balle.v - _balle.r
    and _square.y <= _balle.y + _balle.r + _balle.v and _square.y >= _balle.y + _balle.v - _balle.r  then
      return true
  end
  return false
end

function IntroState:deplacerBalle()
  if self.tempsAttente > 0 then
    self.tempsAttente = self.tempsAttente - 1
  end
  if self.balle.alpha == 1 then
    if self.balle.y >= ECRAN_HAUTEUR then
      self.balle.x = self.vaisseau.x
      self.balle.y = self.vaisseau.y - self.vaisseau.image:getHeight()/2 - self.balle.r
    end
    
    if self.balle.y + self.balle.r + self.balle.vY <= 0 then
      self.balle.vY = -1 * self.balle.vY
    end
    
    if self.balle.x - self.balle.r + self.balle.vX <= 0 or self.balle.x + self.balle.r + self.balle.vX >= ECRAN_LARGEUR then
      self.balle.vX = -1 * self.balle.vX
    end
    
    for k, square in pairs(self.squares) do
      if self:CheckCollision(self.balle,square) then
        --print("balle.x : "..balle.x.." balle.y : "..balle.y)
        if square.alpha == 1 then
          square.alpha = 0
          self.balle.nbCasses = self.balle.nbCasses + 1
        end
        if self.balle.nbCasses >= 100 then
          if self.step == 1 then
            self:createIntro2()
          else
            self:createIntro3()
          end
        end
      end
    end
      
    if self.tempsAttente == 0 then
      if self.balle.y < self.vaisseau.y and math.abs(self.balle.y - self.vaisseau.y) <= self.balle.r + self.vaisseau.h / 2
        and math.abs(self.balle.x - self.vaisseau.x) <= self.balle.r + self.vaisseau.l / 2 then
        self.balle.vY = -1 * self.balle.vY
      end
    end
    
    self.balle.x = self.balle.x + self.balle.vX
    self.balle.y = self.balle.y + self.balle.vY
  end
end

function IntroState:deplacerVaisseau()
  if self.vaisseau.x < self.balle.x then
    if self.vaisseau.x + self.vaisseau.l / 2 + self.vaisseau.v > ECRAN_LARGEUR then
      self.vaisseau.x = ECRAN_LARGEUR - self.vaisseau.l / 2
    else
      self.vaisseau.x = self.vaisseau.x + self.vaisseau.v
    end
  end
  if self.vaisseau.x > self.balle.x then
    if self.vaisseau.x - self.vaisseau.l / 2 - self.vaisseau.v < 0 then
      self.vaisseau.x = self.vaisseau.l / 2
    else
      self.vaisseau.x = self.vaisseau.x - self.vaisseau.v
    end
  end
end

function IntroState:createIntro1()
  local afficherBalle = function () self:afficherBalle() end
  self.step = 1
  flux.to(self.vaisseau, 4, { y = ECRAN_HAUTEUR - 130 })
          :ease("circinout")
          :delay(1)
  flux.to(self.balle, 4, { y = ECRAN_HAUTEUR - 155})
          :ease("circinout")
          :delay(1)
          :oncomplete(afficherBalle)
          
  -- Squares
  local i = 0
  for d_y = 1, 12 do
    for d_x = 1, 80 do
      local t_i = (d_y - 1) * 80 + d_x
      if introGrille.data[t_i] ~= 0 then
        local square = { x = (d_x - 1) * 10, y = (d_y - 1) * 10 + 600, size = 10, alpha = 1}
        table.insert(self.squares, square)
        -- Drop from bottom of screen and fade out randomly
        flux.to(square, 1, { y = (d_y - 1) * 10 + 100 })
          :ease("backout")
          :delay(5 + math.random() * 6)
      end
      i = i + 1
    end
  end
end

function IntroState:createIntro2()
  local afficherBalle = function () self:afficherBalle() end
  self.step = 2
  self.vaisseau.x = ECRAN_LARGEUR / 2
  self.vaisseau.y = ECRAN_HAUTEUR - 130
  
  self.balle.x = self.vaisseau.x
  self.balle.y = self.vaisseau.y - self.vaisseau.image:getHeight()/2 - self.balle.r
  self.balle.alpha = 0
  
  local s
  local i = 0
  --[[for s = 1, #squares do
    squares[s].alpha = 1
  end]]
    
  for s = 1, #self.squares do
    local square = self.squares[s]
    square.alpha = 1
    local d_x = square.x / 10 + 1
    local d_y = (square.y - 600) / 10 + 1

    -- Resize to single pixel diagonally from top-left to bottom-right
    flux.to(square, 2, { size = 1 }):delay(4 + .1 * (d_x + d_y)):ease("quintout")
    
        -- Send a pulse
    flux.to(square, .04, { size = 8 })
    :delay(8 + .005 * i)
    :oncomplete(afficherBalle)
    
    i = i + 1
  end

end

function IntroState:createIntro3()
  self.step = 3
  self.affichePressEnter = false
  self.pressEnterTermine = true
  self.timeToPressEnter = false
  self.vaisseau.x = ECRAN_LARGEUR / 2
  self.vaisseau.y = ECRAN_HAUTEUR - 130
  
  self.balle.x = self.vaisseau.x
  self.balle.y = self.vaisseau.y - self.vaisseau.image:getHeight()/2 - self.balle.r
  self.balle.alpha = 0
  
  local s
  local i = 0
  for s = 1, #self.squares do
    local square = self.squares[s]
    square.alpha = 1
    square.size = 1
    -- Form a circle
    flux.to(square, 2, { x = 400 + math.cos(6.28 / 464 * i) * 250,
                      y = 300 + math.sin(6.28 / 464 * i) * 250,
                      size = 4 })
                    :delay(2 + .01 * i)
                    :ease("quadinout")
                    
    flux.to(self.text, 2, { alpha = 1 }):ease("linear"):delay(10)
            :after(self.text, 2, { alpha = 0 }):ease("linear"):delay(10)
    flux.to(self.signature, 2, { alpha = 1 }):ease("linear"):delay(12)
            :after(self.signature, 2, { alpha = 0 }):ease("linear"):delay(9)
    -- Place randomly and randomise alpha
    flux.to(square, 2, { x = math.random() * 800,
                      y = math.random() * 600,
                      alpha = math.random(),
                      size = 2})
            :delay(13 + math.random() * 4)
            :ease("expoinout")
        
    -- Fall off the bottom of the screen
    flux.to(square, 3, { y = ECRAN_HAUTEUR + 1 })
          :ease("circin"):delay(17 + s * .01)
    flux.to(self.vaisseau, 4, { y = ECRAN_HAUTEUR + 50 })
          :ease("circinout")
          :delay(17)
    i = i + 1
  end
end

function IntroState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 250)
  love.graphics.reset()
end

function IntroState:update(dt)
  
  if next(flux.tweens) ~= nil then
    flux.update(dt)
  elseif self.step == 3 then
    Gamestate.switch(MainMenuState)
  elseif self.balle.alpha == 1 then
    if self.step == 1 then
      self.timeToPressEnter = true
    end
    self:deplacerBalle()
    self:deplacerVaisseau()
  end
  
  if self.timeToPressEnter == true then
    --createIntroduction()
    self.tempsAffichePressEnter = self.tempsAffichePressEnter - dt
    if self.tempsAffichePressEnter < 0 then
      self.affichePressEnter = not self.affichePressEnter
      self.tempsAffichePressEnter = 1
    end
  end
  
  local u
  for u=1, #stars do
    star = stars[u]
    if star.y > ECRAN_HAUTEUR then star.y = 0
    else
      star.y = star.y + star.v
    end
  end
end

function IntroState:leave()
  stars = {}
end

function IntroState:draw()
  love.graphics.draw(listImages['BG'][1].normal, 0, 0)
  for k, square in pairs(self.squares) do
    love.graphics.setColor(255, 255, 255, square.alpha * 255)
    love.graphics.rectangle("fill", square.x, square.y, square.size, square.size)
    --love.graphics.setColor(0, 0, 0, square.alpha * 255)
    --love.graphics.rectangle("line", square.x, square.y, square.size, square.size)
  end
  local d
  for d=1, #stars do
    local star = stars[d]
    love.graphics.setColor(255, 255, 255, star.alpha * 255)
    love.graphics.circle("fill", star.x, star.y, 1)
  end
  love.graphics.draw(self.vaisseau.image, self.vaisseau.x, self.vaisseau.y, 0, 1, 1, self.vaisseau.l / 2, self.vaisseau.h / 2)
  
  love.graphics.setColor(255, 255, 255, self.balle.alpha * 255)
  love.graphics.circle("fill", self.balle.x, self.balle.y, self.balle.r)
  love.graphics.setColor(255, 255, 255, self.text.alpha * 255)
  love.graphics.setFont(self.text.font)
  love.graphics.print(self.text.str, self.text.x, self.text.y)
  love.graphics.setColor(0, 148, 255, self.signature.alpha * 255)
  love.graphics.setFont(self.signature.font)
  love.graphics.print(self.signature.str, self.signature.x, self.signature.y)
  love.graphics.setColor(255, 255, 255, .4 * 255)
  love.graphics.setFont(listFonts['minecraft'].small)
  --love.graphics.print("fps: " .. love.timer.getFPS().. "\n" .."tweens: " .. #flux.tweens, 5, 5)
  if self.affichePressEnter then
    self:dessinerPressEnter()
  end
  --love.graphics.print("fps: " .. love.timer.getFPS() .. "\n" .."tweens: " .. #flux.tweens, 20, 20)
end

function IntroState:keypressed(key)
  if self.timeToPressEnter == true and key == "return" then
    self:createIntro3()
  end
end