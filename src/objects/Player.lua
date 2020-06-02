Player = Class{}

function Player:init()  -- The constructor

	--print("Module / création d'une instance de Player")
  self.name = ""
  self.vies = 0
  self.score = 0
  self.totalTimePlayed = 0
end

function Player:initParameters(difficulty)
  self.score = 0
  if difficulty == 0 then
    self.vies = 7
  elseif difficulty == 1 then
    self.vies = 5
  else
    self.vies = 3
  end
end

function Player:updateLife(number)
  self.vies = self.vies + number
end

function Player:updateScore(number)
  self.score = self.score + number
end