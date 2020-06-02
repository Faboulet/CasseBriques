Balle = Class{}

function Balle:init()  -- The constructor

	--print("Module / création d'une instance vide de Balle")
  self.x = 0
  self.y = 0
  self.r = 7
  self.angle = 0
  self.v = 0
  self.vX = 0
  self.vY = 0
  self.tempsAttente = 0
  self.tempsAvantAcc = 0
  self.ready = false
  self.lastBriqueTouched = {}
end

function Balle:initParameters(difficulty, _vaisseau)
  self.x = _vaisseau.x
  self.y = _vaisseau.y - (_vaisseau.h / 2) - self.r
  self.angle = -5 * math.pi / 8
  
  if difficulty == 0 then
    self.v = 3
  elseif difficulty == 1 then
    self.v = 4
  else
    self.v = 5
  end
  
  self.vX = math.cos(self.angle) * self.v
  self.vY = math.sin(self.angle) * self.v
  self.tempsAttente = 5
  self.tempsAvantAcc = 10
  self.ready = false
  self.lastBriqueTouched = {}
end

function Balle:resetPosition(_vaisseau)
  self.x = _vaisseau.x
  self.y = _vaisseau.y - (_vaisseau.h / 2) - self.r
  self.y = 563
  self.angle = -5 * math.pi / 8
  self.vX = math.cos(self.angle) * self.v
  self.vY = math.sin(self.angle) * self.v
  self.tempsAttente = 5
  self.tempsAvantAcc = 10
  self.ready = false
  self.lastBriqueTouched = {}
end

function Balle:updateVitesse(number)
  self.v = self.v + number
end

function Balle:deplacerGererCollisions(_jeu, _player, _vaisseau, _briques)
  --[[if self.v ~= testVitesse then
    print("Vitesse = "..self.v)
    testVitesse = self.v
  end]]
  
  if self.tempsAttente >= 1 then
    self.tempsAttente = self.tempsAttente - 1
  end
  
  if self.y >= ECRAN_HAUTEUR then
    self.lastBriqueTouched = {}
    if _player.vies - 1 == 0 then
      Gamestate.switch(GameOverState, _jeu, _player)
      return
    else
      _player:updateLife(-1)
      _vaisseau:resetPosition()
      self:resetPosition(_vaisseau)
      return
    end
  end
  
  if self.y + self.r / 2 + self.vY <= LIMITE_HAUTE then
    self.lastBriqueTouched = {}
    -- acceleration tous les 10 murs touchés
    -- permet d'eviter les blocages
    self.tempsAvantAcc = self.tempsAvantAcc - 1
    if self.tempsAvantAcc == 0 then
      self.vX = 1.01 * self.vX
      self.vY = 1.01 * self.vY
      self.tempsAvantAcc = 10
    end
    self.vY = -1 * self.vY
  end
  
  if self.x - self.r / 2 + self.vX <= LIMITE_GAUCHE
    or self.x + self.r + self.vX >= LIMITE_DROITE then
    self.lastBriqueTouched = {}
    -- acceleration tous les 10 murs touchés
    -- permet d'eviter les blocages
    self.tempsAvantAcc = self.tempsAvantAcc - 1
    if self.tempsAvantAcc == 0 then
      self.vX = 1.01 * self.vX
      self.vY = 1.01 * self.vY
      self.tempsAvantAcc = 10
    end
    self.vX = -1 * self.vX
  end
  
  if self.tempsAttente == 0 then
    if self.y < _vaisseau.y and math.abs(self.y - _vaisseau.y) <= self.r / 2 + _vaisseau.h / 2
      and math.abs(self.x - _vaisseau.x) <= self.r / 2 + _vaisseau.l / 2 then
      self.lastBriqueTouched = {}
      -- print("joueur touché")
      self.tempsAttente = 5
      listSounds['sonShoot']:play()
      -- print("Avant vx : "..balle.vX.." vY : "..balle.vY)
      if self.x < _vaisseau.x - 1/3 * _vaisseau.l then
        self.angle = -7 * math.pi / 8
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
        -- print("bord g vx : "..balle.vX.." vY : "..balle.vY)
      elseif self.x > _vaisseau.x + 1/3 * _vaisseau.l then
        self.angle = -1 * math.pi / 8
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
        -- print("bord d vx : "..balle.vX.." vY : "..balle.vY)
      elseif self.x < _vaisseau.x - 1/4 * _vaisseau.l then
        self.angle = -3 * math.pi / 4
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
        -- print("presque bord g : "..balle.vX.." vY : "..balle.vY)
      elseif self.x > _vaisseau.x + 1/4 * _vaisseau.l then
        self.angle = -1 * math.pi / 4
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
        -- print("preque bord d : "..balle.vX.." vY : "..balle.vY)
      elseif self.x < _vaisseau.x then
        self.angle = -5 * math.pi / 8
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
      else
        self.angle = -3 * math.pi / 8
        self.vX = math.cos(self.angle) * self.v
        self.vY = math.sin(self.angle) * self.v
      end
    end
  end
  
  local n
  for n = #_briques, 1, -1 do
    local touche = false
    local brique = _briques[n]
    if math.abs(self.x - brique.x)  <= math.abs(self.r + brique.l / 2) and
      math.abs(self.y - brique.y) <= math.abs(self.r + brique.h / 2) then
      -- print("Brique : X = "..brique.x.." Y = "..brique.y.." Balle : X = "..balle.x.."vX = "..balle.vX.." Y = "..balle.y.." vY = "..balle.vY)
      if ((self.y <= brique.y + brique.h / 2 and self.y - self.vY >= brique.y + brique.h / 2) or
        (self.y >= brique.y - brique.h / 2 and self.y - self.vY <= brique.y - brique.h / 2))  then
        -- print("A- Brique : X = "..brique.x.." Y = "..brique.y.." Balle : X = "..balle.x.."vX = "..balle.vX.." Y = "..balle.y.." vY = "..balle.vY)
        -- print("brique touchée")
        self.vY = - 1 * self.vY
        if touche == false then
          touche = true
        end
      end
        -- print("A+ Brique : X = "..brique.x.." Y = "..brique.y.." Balle : X = "..balle.x.."vX = "..balle.vX.." Y = "..balle.y.." vY = "..balle.vY)
      if ((self.x <= brique.x + brique.l / 2 and self.x - self.vX >= brique.x + brique.l / 2) or
          (self.x >= brique.x - brique.l / 2 and self.x - self.vX <= brique.x - brique.l / 2))  then
        -- print("B- Brique : X = "..brique.x.." Y = "..brique.y.." Balle : X = "..balle.x.."vX = "..balle.vX.." Y = "..balle.y.." vY = "..balle.vY)
        -- print("brique touchée")
        self.vX = - 1 * self.vX
        if touche == false then
          touche = true
        end
        -- print("B+ Brique : X = "..brique.x.." Y = "..brique.y.." Balle : X = "..balle.x.."vX = "..balle.vX.." Y = "..balle.y.." vY = "..balle.vY)
      end
      if touche == true then
        if brique.infini == false then
          if next(self.lastBriqueTouched) == nil
           or self.lastBriqueTouched.x ~= brique.x
            or self.lastBriqueTouched.y ~= brique.y then
            _player:updateScore(1+_jeu.difficulty)
            listSounds['sonExplode']:play()
            brique.vie = brique.vie - 1
            if brique.vie == 0 then
              table.remove(_briques, n)
              if #_briques == _jeu.nbBriquesIncassables then
                if _jeu.currentLevel + 1 > NB_LEVELS then
                  Gamestate.switch(GameCompleteState, _jeu, _player)
                  return
                else
                  local params = {}
                  params.no = _jeu.currentLevel + 1
                  Gamestate.switch(NextLevelState, false, params)
                  return
                end
              end
            end
          end
        else
          -- acceleration tous les 10 murs touchés
          -- permet d'eviter les blocages
          self.tempsAvantAcc = self.tempsAvantAcc - 1
          if self.tempsAvantAcc == 0 then
            self.vX = 1.01 * self.vX
            self.vY = 1.01 * self.vY
            self.tempsAvantAcc = 10
          end
        end
        self.lastBriqueTouched.x = brique.x          
        self.lastBriqueTouched.y = brique.y
      end
    end
  end
  
  self.x = self.x + self.vX
  self.y = self.y + self.vY
  -- return briques
  -- print("X: "..balle.x.." vX : "..balle.vX.." Y: "..balle.y.." vY : "..balle.vY)
end