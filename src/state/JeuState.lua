JeuState = {}

function JeuState:init()

  self.jeu = {}
  
  self.player = {}
  
  self.enPause = false
  
  self.limites = {}
  self.vaisseau = {}
  self.balle = {}
  self.quads = {}
  self.layers = {}
  self.briques = {}
  self.items = {}
  
  self.saveMessage = {}
  self.saveMessage.x = 350
  self.saveMessage.y = 160
  self.saveMessage.text = ""
  self.saveMessage.font = listFonts['minecraft'].normal
  
  self.pauseMenu = PauseMenu()
end

function JeuState:enter(_, _jeu, _player, _limites, _vaisseau, _balle, _quads, _layers, _briques)
  
  self.jeu = _jeu
  BACKGROUND_IMAGE = listImages['BG'][self.jeu.currentLevel]
  
  self.player = _player
  self.limites = _limites
  self.vaisseau = _vaisseau
  self.balle = _balle
  self.quads = _quads
  self.layers = _layers
  self.briques = _briques
  self:initDrawLimites()
  --self:initDraw()
end

--[[function JeuState:initDraw()
  self.vaisseau.y = ECRAN_HAUTEUR + self.vaisseau.h
  self.balle.y = self.vaisseau.y - self.vaisseau.h / 2 - self.balle.r
  
  flux.to(self.vaisseau, 3, { y = ECRAN_HAUTEUR - 20 })
      :ease("backout")
  flux.to(self.balle, 3, { y = ECRAN_HAUTEUR - 20 - self.vaisseau.h / 2 - self.balle.r })
      :ease("backout")
end]]

function JeuState:initDrawLimites()
  self.limites['gauche'].x = self.limites['gauche'].x - self.limites['gauche'].l
  self.limites['droite'].x = self.limites['droite'].x + 2 * self.limites['droite'].l
  self.limites['haute'].y = self.limites['haute'].y - self.limites['haute'].h
  
  flux.to(self.limites['gauche'], 3, { x = 0 })
      :ease("backout")
  flux.to(self.limites['droite'], 3, { x = ECRAN_LARGEUR - self.limites['droite'].l })
      :ease("backout")
  flux.to(self.limites['haute'], 3, { y = 0 })
      :ease("backout")
end

function JeuState:saveGame()
  local save = {
    jeu = self.jeu,
    player=self.player,
    vaisseau={
      x = self.vaisseau.x,
      y = self.vaisseau.y,
      v = self.vaisseau.v
    },
    balle=self.balle,
    briques=self.briques
  }
  local success, errorString = persistence.persistSave(save)
  if not success then 
    self.saveMessage.text = "Following error occured with save file"..errorString
  else
    self.saveMessage.text = "Save OK"
  end
end

function JeuState:update(dt)
  if next(flux.tweens) ~= nil then
    flux.update(dt)
  elseif self.enPause == false then
    self.player.totalTimePlayed = self.player.totalTimePlayed + dt
    self.jeu.timeElapsed = self.jeu.timeElapsed + dt
    self.jeu.totalTimeElapsed = self.jeu.totalTimeElapsed + dt
    if self.balle.ready == true then
      self.balle:deplacerGererCollisions(self.jeu, self.player, self.vaisseau, self.briques)
      -- print("briques = "..#briques)
    end

    if love.keyboard.isDown('right') then
      if self.vaisseau.x + self.vaisseau.l / 2 + self.vaisseau.v <= LIMITE_DROITE then
        self.vaisseau.x = self.vaisseau.x + self.vaisseau.v
        if self.balle.ready == false then
          self.balle.x = self.balle.x + self.vaisseau.v
        end
      else
        self.vaisseau.x = LIMITE_DROITE - self.vaisseau.l / 2
      end
    end
    
    if love.keyboard.isDown('left') then
      if self.vaisseau.x - self.vaisseau.l / 2 - self.vaisseau.v >= LIMITE_GAUCHE then
        self.vaisseau.x = self.vaisseau.x - self.vaisseau.v
        if self.balle.ready == false then
          self.balle.x = self.balle.x - self.vaisseau.v
        end
      else
        self.vaisseau.x = LIMITE_GAUCHE + self.vaisseau.l / 2
      end
    end
    
    if love.keyboard.isDown('space') and self.balle.ready == false then
      self.balle.ready = true
    end
  else
    self.pauseMenu.tempsAffichageMessage = self.pauseMenu.tempsAffichageMessage - dt
    if self.pauseMenu.tempsAffichageMessage <= 0 then
      self.pauseMenu.affichageMessage = not self.pauseMenu.affichageMessage
      self.pauseMenu.tempsAffichageMessage = 1
    end
  end
end 

function JeuState:afficheSaveMessage()
  love.graphics.setColor(1, 0, 0) -- on met la couleur en rouge
  love.graphics.setFont(self.saveMessage.font)
  love.graphics.print(self.saveMessage.text, self.saveMessage.x, self.saveMessage.y)
  love.graphics.reset()
end

function JeuState:draw()
  
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  self:drawLimites()
  self:drawBriques()
  self:drawVaisseau()

  self:drawScore()
  self:drawLife()
  self:drawTemps()
  self:drawTempsTotal()
  self:drawBalle()
  
  if self.enPause then
    self.pauseMenu:drawPauseMenu()
    self:afficheSaveMessage()
  end
  
end

function JeuState:keypressed(key)
  if self.enPause == false then
    if key == "p" then
      self.enPause = true
    end
  else
    self.saveMessage.text = ""
    if key == "up" then
      self.pauseMenu:selectPauseMenu((self.pauseMenu.pauseMenuSelected - 1) % self.pauseMenu.nbPauseMenu)
    end
    if key == "down" then
      self.pauseMenu:selectPauseMenu((self.pauseMenu.pauseMenuSelected + 1) % self.pauseMenu.nbPauseMenu)
    end
    if key == "return" then
      if self.pauseMenu.pauseMenuSelected == 2 then
        self.enPause = false
        self.pauseMenu.pauseMenuSelected = 0
        Gamestate.switch(MainMenuState)
      elseif self.pauseMenu.pauseMenuSelected == 1 then
        -- Sauvegarder la partie
        self:saveGame()
      else
        self.enPause = false
      end
    end
  end
end

function JeuState:drawLimites()
  --dessiner les limites du terrain
  love.graphics.draw(self.limites['gauche'].image, self.limites['gauche'].x, self.limites['gauche'].y)
  love.graphics.draw(self.limites['droite'].image, self.limites['droite'].x, self.limites['droite'].y)
  love.graphics.draw(self.limites['haute'].image, self.limites['haute'].x, self.limites['haute'].y)
end

function JeuState:drawScore()
  
  love.graphics.setColor(1, 1, 1) -- on met la couleur
  love.graphics.setFont(listFonts['orbitron'].normal)
  love.graphics.print("SCORE "..self.player.score, 35, 25)
  love.graphics.reset()
end

function JeuState:drawTemps()
  love.graphics.setColor(1, 1, 1) -- on met la couleur en blanc
  love.graphics.setFont(listFonts['orbitron'].normal)
  love.graphics.print("TIME "..formatTime(self.jeu.timeElapsed), 190, 25)
  love.graphics.reset()
end

function JeuState:drawTempsTotal()
  love.graphics.setColor(1, 1, 1) -- on met la couleur en blanc
  love.graphics.setFont(listFonts['orbitron'].normal)
  love.graphics.print("TOTAL TIME "..formatTime(self.jeu.totalTimeElapsed), 350, 25)
  love.graphics.reset()
end

function JeuState:drawLife()
  if self.player.vies ~= 0 then
    local decalage = 0
    local vies
    for vies = 1, self.player.vies do
      love.graphics.draw(listImages['vie'], ECRAN_LARGEUR - 50 - decalage, 20, 0, 1, 1)
      decalage = decalage + 20
    end
  end
end

function JeuState:drawBalle()
  -- Dessiner la balle
  love.graphics.setColor(1, 1, 0)
  love.graphics.circle('fill', self.balle.x, self.balle.y, self.balle.r)
  love.graphics.reset()
end

function JeuState:drawVaisseau()
  --dessiner le vaisseau
  love.graphics.draw(self.vaisseau.image, self.vaisseau.x, self.vaisseau.y, 0, 1, 1, self.vaisseau.l/2, self.vaisseau.h/2)
end

function JeuState:drawBriques()
  local n
  for n=1, #self.briques do
    local s = self.briques[n]
    love.graphics.draw(listTileMap['briques'], self.quads[s.indiceImage], s.x, s.y, 0, 1, 1, s.l / 2, s.h / 2)
    if (s.infini ~= true) then
      love.graphics.print(s.vie, s.x - 2, s.y - 8)
    end
  end
end