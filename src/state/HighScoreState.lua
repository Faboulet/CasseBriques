HighScoreState = {}

function HighScoreState:init()
  
  self.x = 0
  self.y = 0
  
  self.title = {}
  self.title.text = "HIGHSCORES"
  self.title.font = listFonts['minecraft'].huge
  self.title.x = 140
  self.title.y = -250
  
  self.affichageMessage = false
  self.tempsAffichageMessage = 1
  
  self.highscoreTable = {}
  
  self:initDraw()
end

function HighScoreState:initDraw()
  flux.to(self.title, 3, { y = 50 })
      :ease("backout")
end

function HighScoreState:enter(_, jeu, player)
  local resultatHighScore = persistence.fetchHighscore()
  if resultatHighScore ~= nil then
    self.highscoreTable = resultatHighScore
  end
  if jeu ~= nil and player ~= nil then
    self:gererHighscores(jeu, player)
  end
  BACKGROUND_IMAGE = listImages['BG'][1]
end

function HighScoreState:update(dt)
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

function HighScoreState:dessinerPressEnter()
  
  love.graphics.setColor(0, 148, 255) -- on met la couleur
  love.graphics.setFont(listFonts['minecraft'].big)
  love.graphics.print("PRESS ENTER TO START", 220, 520)
  love.graphics.reset()
end

function HighScoreState:draw()
  -- dessiner le background
  love.graphics.draw(BACKGROUND_IMAGE.normal, self.x, self.y)
  
  love.graphics.setColor(1, 1, 1) -- on met la couleur en blanc
  love.graphics.setFont(self.title.font)
  love.graphics.print(self.title.text, self.title.x, self.title.y)
  love.graphics.setFont(listFonts['orbitron'].idle)
  love.graphics.print("NAME", 130, 152)
  love.graphics.print("SCORE", 365, 152)
  love.graphics.print("TOTAL TIME", 530, 152)
  love.graphics.rectangle("fill", 110, 177, 575, 2)
  local decalage_v = 0
  for i = 1, #self.highscoreTable do
    local highscore = self.highscoreTable[i]
    love.graphics.print(i, 80, 187+decalage_v)
    love.graphics.rectangle("fill", 110, 177 + decalage_v, 2, 31)
    love.graphics.print(highscore[3], 130, 187 + decalage_v)
    love.graphics.print(highscore[1], 365, 187 + decalage_v)
    love.graphics.print(formatTime(highscore[2]), 600, 187 + decalage_v)
    love.graphics.rectangle("fill", 70, 187 + decalage_v + 20, 615, 2)
    decalage_v = decalage_v + 31
  end
  love.graphics.reset()
  if self.affichageMessage then
    self:dessinerPressEnter()
  end
end

function HighScoreState:gererHighscores(_jeu, _player)
  
  local newHighscoreTable = {}
  local line = { _player.score, _jeu.totalTimeElapsed, _player.name}

  if next(self.highscoreTable) == nil then
    table.insert(newHighscoreTable, line)
  else
    local trouve = false
    for i = 1, #self.highscoreTable do
      if tonumber(line[1]) > tonumber(self.highscoreTable[i][1])
        or (tonumber(line[1]) == tonumber(self.highscoreTable[i][1])
          and tonumber(line[2]) < tonumber(self.highscoreTable[i][2]))
        or (tonumber(line[1]) == tonumber(self.highscoreTable[i][1])
          and tonumber(line[2]) == tonumber(self.highscoreTable[i][2])
          and tostring(line[3]) < tostring(self.highscoreTable[i][3])) then
        if trouve == false then
          table.insert(newHighscoreTable, line)
          trouve = true
        end
      end
      table.insert(newHighscoreTable, self.highscoreTable[i])
    end
    if trouve == false then
      table.insert(newHighscoreTable, line)
    end
    newHighscoreTable = self:supprimerDoublons(newHighscoreTable, _player.name)
    if #newHighscoreTable > 10 then
      for i = #newHighscoreTable, 11, -1 do
        table.remove(newHighscoreTable,i)
      end
    end
  end
  
  if not self:compareTables(newHighscoreTable, self.highscoreTable) then
    self.highscoreTable = newHighscoreTable
    persistence.persistHighscore(newHighscoreTable)
  end
  
end

function HighScoreState:supprimerDoublons(_table, _name)
  local i
  local index = 0
  for i = 1, #_table do
    if _table[i][3] == _name then
      index = i
      break
    end
  end
  --print("index = "..index)
  for i = #_table, index + 1, -1 do
    if _table[i][3] == _name then
      table.remove(_table, i)
    end
  end
  return _table
end

function HighScoreState:compareTables(table1, table2)
  if #table1 ~= #table2 then
    return false
  else
    for i = 1, #table1 do
      if tonumber(table1[i][1]) ~= tonumber(table2[i][1])
        or tonumber(table1[i][2]) ~= tonumber(table2[i][2])
        or tostring(table1[i][3]) ~= tostring(table2[i][3]) then
        return false
      end
    end
  end
  return true
end

function HighScoreState:keypressed(key)
  if key == "return" then
    Gamestate.switch(MainMenuState)
  end
end