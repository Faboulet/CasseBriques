MainMenuState = {}

local stars = {}

function MainMenuState:init()  -- The constructor

	-- print("Module / création d'une instance de Main Menu")
  self.x = 0
  self.y = 0
  
  self.title = {}
  self.title.text = "CASSE BRIQUE"
  self.title.x = 100
  self.title.y = -250
  self.nbMenus = 5
  self.listeMenus = {}
  self.menuSelected = 0
  
  self.nbSideMenus = 3
  self.listeSideMenus = {}
  self.sideMenuSelected = 0
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self.difficulty = 1 -- 1 correspond à Medium, 0 à Easy et 2 à difficult
  
  self:initDraw()
end

function MainMenuState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
  self.listeMenus[0] = self:initButton("START GAME", -300, 180, -265, 210)
  flux.to(self.listeMenus[0], 2, { x = 290 })
      :ease("elasticout")
  flux.to(self.listeMenus[0].label, 2, { x = 325 })
      :ease("elasticout")
  self.listeMenus[1] = self:initButton("LOAD GAME", ECRAN_LARGEUR + 290, 255, ECRAN_LARGEUR + 330, 285)
  flux.to(self.listeMenus[1], 2, { x = 290 })
      :ease("elasticout")
  flux.to(self.listeMenus[1].label, 2, { x = 330 })
      :ease("elasticout")
  self.listeMenus[2] = self:initButton("OPTIONS", -300, 330, -245, 360)
  flux.to(self.listeMenus[2], 2, { x = 290})
      :ease("elasticout")
  flux.to(self.listeMenus[2].label, 2, { x = 345 })
      :ease("elasticout")
  self.listeMenus[3] = self:initButton("COMMANDS", ECRAN_LARGEUR + 290, 405, ECRAN_LARGEUR + 330, 435)
  flux.to(self.listeMenus[3], 2, { x = 290 })
      :ease("elasticout")
  flux.to(self.listeMenus[3].label, 2, { x = 330 })
      :ease("elasticout")
  self.listeMenus[4] = self:initButton("QUIT GAME", -300, 480, -260, 510)
  flux.to(self.listeMenus[4], 2, { x = 290 })
      :ease("elasticout")
  flux.to(self.listeMenus[4].label, 2, { x = 330 })
      :ease("elasticout")
end

function MainMenuState:initButton(_text, _x, _y, _labelX, _labelY)
  local button = {}
  button.x = _x
  button.y = _y
  button.label = {}
  button.label.x = _labelX
  button.label.y = _labelY
  button.label.text = _text
  return button
end

function MainMenuState:enter()
  local s
  for s=1, 50 do
    local star = {}
    star.x = math.random() * 800
    star.y = math.random() * 600
    star.alpha = math.random()
    star.v = math.random(5)
    table.insert(stars, star)
  end
  BACKGROUND_IMAGE = listImages['BG'][1]
  --[[self.listeMenus[0] = self:initButton("START GAME", 290, 180, 325, 210)
  self.listeMenus[1] = self:initButton("LOAD GAME", 290, 255, 330, 285)
  self.listeMenus[2] = self:initButton("OPTIONS", 290, 330, 345, 360)
  self.listeMenus[3] = self:initButton("COMMANDS", 290, 405, 330, 435)
  self.listeMenus[4] = self:initButton("QUIT GAME", 290, 480, 330, 510)]]
end

function MainMenuState:resume(_, _difficulty)
    if _difficulty ~= nil then
    self.difficulty = _difficulty
  end
end

function MainMenuState:update(dt)
  if next(flux.tweens) ~= nil then
    flux.update(dt)
  else
    self.tempsAffichageMessage = self.tempsAffichageMessage - dt
    if self.tempsAffichageMessage <= 0 then
      self.affichageMessage = not self.affichageMessage
      self.tempsAffichageMessage = 1
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

function MainMenuState:selectMenu(number)
  self.menuSelected = number
end

function MainMenuState:enterMenu()
  if self.menuSelected == 0 then
    Gamestate.switch(EnterNameState, self.difficulty)
  elseif self.menuSelected == 1 then
    Gamestate.switch(LoadGameState)
  elseif self.menuSelected == 2 then
    Gamestate.push(OptionState)
  elseif self.menuSelected == 3 then
    Gamestate.push(CommandState)
  elseif self.menuSelected == 4 then
    love.event.quit()
  end
end

function MainMenuState:drawButtons()
  local i
  for i = 0, self.nbMenus - 1 do
    if i == self.menuSelected and self.affichageMessage then
      love.graphics.draw(listImages['button'].selected, self.listeMenus[i].x, self.listeMenus[i].y)
      love.graphics.draw(listImages['button'].leftSelect,
        self.listeMenus[i].x - 30 - listImages['button'].leftSelect:getWidth(), self.listeMenus[i].y)
      love.graphics.draw(listImages['button'].rightSelect,
        self.listeMenus[i].x + listImages['button'].selected:getWidth() + 30, self.listeMenus[i].y)
      --love.graphics.setColor(112, 112, 33) -- on met la couleur jaune si sélectionnée
      love.graphics.setColor(196, 196, 0) -- on met la couleur jaune si sélectionnée
    else
      love.graphics.draw(listImages['button'].normal, self.listeMenus[i].x, self.listeMenus[i].y)
      love.graphics.setColor(1, 1, 1) -- on met la couleur blanche
    end
    love.graphics.setFont(listFonts['minecraft'].normal)
    love.graphics.print(self.listeMenus[i].label.text, self.listeMenus[i].label.x, self.listeMenus[i].label.y)
    love.graphics.reset()
  end
end

function MainMenuState:leave()
  stars = {}
end

function MainMenuState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, self.x, self.y)
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  local d
  for d=1, #stars do
    local star = stars[d]
    love.graphics.setColor(255, 255, 255, star.alpha * 255)
    love.graphics.circle("fill", star.x, star.y, 1)
  end
  
  self:drawButtons()
  love.graphics.reset()
end

function MainMenuState:keypressed(key)
  if next(flux.tweens) == nil then
    if key == "up" then
      self:selectMenu((self.menuSelected - 1) % self.nbMenus)
    end
    if key == "down" then
      self:selectMenu((self.menuSelected + 1) % self.nbMenus)
    end
    if key == "return" then
      self:enterMenu()
    end
  end
end