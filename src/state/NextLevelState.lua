NextLevelState = {}

function NextLevelState:init()
  
  self.no = 0
  self.tilemapImage = listTileMap['briques']
  
  self.decalage_v = 5
  self.decalage_h = 5
  
  self.map = {}
  self.typeBriques = {}
  self.quads = {}
  self.layers = {}
  self.briques = {}
  self.limites = {}
  
  self.jeu = Jeu()
  self.player = Player()
  self.vaisseau = Vaisseau()
  self.balle = Balle()
  
  self:initTypeBriques()
  self:initLimites()
  
end

function NextLevelState:initQuads()
  
  self.quads = {}
  self.layers = {}

  local map = self.map
  -- map variables
  local map_w = map.width
  local map_h = map.height
  local tile_w = map.tilewidth
  local tile_h = map.tileheight
  local tileset_w = map.tilesets[1].imagewidth / tile_w
  local tileset_h = map.tilesets[1].imageheight / tile_h 
  
  for t_y = 0, tileset_h - 1 do
		for t_x = 0, tileset_w - 1 do
			local t_quad = love.graphics.newQuad(t_x * tile_w, t_y * tile_h, tile_w, tile_h, self.tilemapImage:getDimensions())
      table.insert(self.quads, t_quad)
		end
	end
	for t_l = 1, #map.layers do
		if map.layers[t_l].type == "tilelayer" then
      table.insert(self.layers, map.layers[t_l].data)
      -- print("glayer "..#g_layer[#g_layer])
		end
	end
end
  
function NextLevelState:initMap()
  
  self.briques = {}
  
  local map = self.map
  -- map variables
  local map_w = map.width
  local map_h = map.height
  local tile_w = map.tilewidth
  local tile_h = map.tileheight
  
  -- Assigner les briques à la Map
  for t_l = 1, #self.layers  do
    local decalage_v = self.decalage_v
    for d_y = map_h, 1, -1 do
      local decalage_h = self.decalage_h
      for d_x = 1, map_w do
        t_i = (d_y -1) * map_w + d_x
        if self.layers[t_l][t_i] ~= 0 then
          local x = d_x * tile_w - tile_w + LIMITE_GAUCHE + decalage_h
          local y = d_y * tile_h - tile_h - (map_h * tile_h - ECRAN_HAUTEUR) - decalage_v + 100
          table.insert(self.briques, self:gererBrique(self.layers[t_l][t_i], x, y, tile_w, tile_h))
          -- print("No = "..g_layer[t_l][t_i].." x = "..x.." y = "..y)
        end
        decalage_h = decalage_h + self.decalage_h
      end
      decalage_v = decalage_v + self.decalage_v
    end
	end
end

function NextLevelState:initTypeBriques()
  self.typeBriques[1] = { vie = 2, move = false, infini = false } -- brique bleu foncé
	self.typeBriques[2] = { vie = 3, move = false, infini = false } -- brique verte
	self.typeBriques[3] = { vie = 4, move = false, infini = false } -- brique bleue clair
	self.typeBriques[4] = { vie = 5, move = false, infini = false } -- brique orange
	self.typeBriques[5] = { vie = 6, move = false, infini = false } -- brique rose
	self.typeBriques[6] = { vie = 7, move = false, infini = false } -- brique violet
	self.typeBriques[7] = { vie = 8, move = false, infini = false } -- brique rouge
  self.typeBriques[8] = { vie = 1, move = false, infini = false } -- brique jaune
	self.typeBriques[9] = { vie = 10, move = false, infini = true } -- brique gris

end

function NextLevelState:gererBrique(indice, posX, posY, largeur, hauteur )
  if self.typeBriques[indice].infini then self.jeu.nbBriquesIncassables = self.jeu.nbBriquesIncassables + 1 end
  return Brique(posX, posY, indice, largeur, hauteur,
    self.typeBriques[indice].infini, self.typeBriques[indice].vie, self.typeBriques[indice].move)
end

function NextLevelState:initLimites()
  self.limites['haute'] = {}
  self.limites['haute'].image = listImages['limite'].haute
  self.limites['haute'].l = self.limites['haute'].image:getWidth()
  self.limites['haute'].h = self.limites['haute'].image:getHeight()
  self.limites['haute'].x = 0
  self.limites['haute'].y = 0
  
  LIMITE_HAUTE = self.limites['haute'].y + self.limites['haute'].h
  
  self.limites['gauche'] = {}
  self.limites['gauche'].image = listImages['limite'].gauche
  self.limites['gauche'].l = self.limites['gauche'].image:getWidth()
  self.limites['gauche'].h = self.limites['gauche'].image:getHeight()
  self.limites['gauche'].x = 0
  self.limites['gauche'].y = self.limites['haute'].h
  
  LIMITE_GAUCHE = self.limites['gauche'].x + self.limites['gauche'].l
  
  self.limites['droite'] = {}
  self.limites['droite'].image = listImages['limite'].droite
  self.limites['droite'].l = self.limites['droite'].image:getWidth()
  self.limites['droite'].h = self.limites['droite'].image:getHeight()
  self.limites['droite'].x = ECRAN_LARGEUR - self.limites['droite'].l
  self.limites['droite'].y = self.limites['haute'].h
  
  LIMITE_DROITE = self.limites['droite'].x
end

function NextLevelState:initDraw()
  self.title = {}
  self.title.text = "NEXT LEVEL"
  self.title.x = 150
  self.title.y = -250
  
  self.content = {}
  self.content.text = "LEVEL "..self.no
  self.content.x = 300
  self.content.y = -150
  
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
  flux.to(self.content, 3, { y = 230 })
      :ease("backout")
end

function NextLevelState:enter(_, _saveToLoad, _params)
  BACKGROUND_IMAGE = listImages['BG'][1]
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  if _saveToLoad then
    
    self.jeu.difficulty = _params.jeu.difficulty
    self.jeu.currentLevel = _params.jeu.currentLevel
    self.no = self.jeu.currentLevel
    self.map = require("assets/maps/level"..self.no)
    self:initQuads()
    
    self.jeu.timeElapsed = _params.jeu.timeElapsed
    self.jeu.totalTimeElapsed = _params.jeu.totalTimeElapsed
    self.jeu.nbBriquesIncassables = _params.jeu.nbBriquesIncassables
    
    self.player.name = _params.player.name
    self.player.score = _params.player.score
    self.player.vies = _params.player.vies
    self.player.totalTimePlayed = _params.player.totalTimePlayed
    
    self.vaisseau.x = _params.vaisseau.x
    self.vaisseau.y = _params.vaisseau.y
    self.vaisseau.v = _params.vaisseau.v
    
    self.balle.x = _params.balle.x
    self.balle.y = _params.balle.y
    self.balle.r = _params.balle.r
    self.balle.angle = _params.balle.angle
    self.balle.v = _params.balle.v
    self.balle.vX = _params.balle.vX
    self.balle.vY = _params.balle.vY
    self.balle.tempsAttente = _params.balle.tempsAttente
    self.balle.tempsAvantAcc = _params.balle.tempsAvantAcc
    self.balle.ready = _params.balle.ready
    self.balle.lastBriqueTouched = _params.balle.lastBriqueTouched
    
    self.briques = _params.briques
    
  else
    self.no = _params.no
    self.jeu.timeElapsed = 0
    self.jeu.nbBriquesIncassables = 0
    self.jeu.currentLevel = self.no
    self.map = require("assets/maps/level"..self.no)
    self:initQuads()
    self:initMap()
    
    if self.no == 1 then
      self.jeu.totalTimeElapsed = 0
      self.player.name = _params.name
      self.jeu.difficulty = _params.difficulty
      
      self.player:initParameters(self.jeu.difficulty)
      self.vaisseau:initParameters(self.jeu.difficulty)
      self.balle:initParameters(self.jeu.difficulty, self.vaisseau)
    else
      self.vaisseau:resetPosition()
      self.vaisseau:updateVitesse(0.5)
      self.balle:resetPosition(self.vaisseau)
      self.balle:updateVitesse(0.5)
    end
    
  end
  self:initDraw()
end

function NextLevelState:update(dt)
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

function NextLevelState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, 0, 0)
  
  love.graphics.setColor(1, 1, 1) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].huge)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  
  love.graphics.setFont(listFonts['minecraft'].bigger)
  love.graphics.print(self.content.text, self.content.x, self.content.y)
  
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
  
end

function NextLevelState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function NextLevelState:keypressed(key)
  if next(flux.tweens) == nil and key == "return" then
    Gamestate.switch(JeuState, self.jeu, self.player, self.limites, self.vaisseau, self.balle, self.quads, self.layers, self.briques)
  end
end