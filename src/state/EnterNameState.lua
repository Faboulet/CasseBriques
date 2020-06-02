EnterNameState = {}

function EnterNameState:init()
  
  self.title = {}
  self.title.text = "ENTER NAME"
  self.title.font = listFonts['minecraft'].huge
  self.title.x = 120
  self.title.y = -100

  self.text = {}
  self.text.font = listFonts['orbitron'].large
  self.text.name = ""
  self.text.x = 230
  self.text.y = 200
  self.text.box = {}
  self.text.box.x = self.text.x - 20
  self.text.box.y = -50
  self.text.box.l = 380
  self.text.box.h = 70
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self.difficulty = 1
  
  self:initDraw()
end

function EnterNameState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
  flux.to(self.text.box, 3, { y = self.text.y - 20 })
      :ease("backout")
end

function EnterNameState:enter(_, _difficulty)
  self.difficulty = _difficulty
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function EnterNameState:leave()
  
end

function EnterNameState:update(dt)
  if next(flux.tweens) ~= nil then
    flux.update(dt)
  else
    self.tempsAffichageMessage = self.tempsAffichageMessage - dt
    if self.tempsAffichageMessage <= 0 then
      self.affichageMessage = not self.affichageMessage
      self.tempsAffichageMessage = 1
    end
    if string.len(self.text.name) > 10 then
      self.text.name = string.sub(self.text.name, 1, 10)
    end
  end
end

function EnterNameState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function EnterNameState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setColor(0, 0, 0) -- on met la couleur en noir
  love.graphics.rectangle('fill', self.text.box.x, self.text.box.y, self.text.box.l, self.text.box.h)
  
  love.graphics.setColor(1, 1, 1) -- on met la couleur en blanc
  love.graphics.setFont(self.title.font)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  love.graphics.setFont(self.text.font)
  if self.affichageMessage then
    love.graphics.print(self.text.name.."_", self.text.x, self.text.y)
    self:dessinerPressEnter()
  else
    love.graphics.print(self.text.name, self.text.x, self.text.y)
  end
  love.graphics.reset()
end

function EnterNameState:keypressed(key)
  if next(flux.tweens) == nil then
    if string.len(self.text.name) > 0 and key == "return" then
      local parameters = {}
      parameters.no = 1
      parameters.difficulty = self.difficulty
      parameters.name = self.text.name
      -- print("name = "..parameters.name.." difficulty = "..parameters.difficulty)
      Gamestate.switch(NextLevelState, false, parameters)
    else
      -- Filtrer les caractères
      if key == "backspace" then
        self.text.name = string.sub(self.text.name, 1, string.len(self.text.name) - 1)
      else
        if string.find("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",key) then
          self.text.name = self.text.name..string.upper(key)
        end
      end
    end
  end
end