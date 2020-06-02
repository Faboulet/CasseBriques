Jeu = Class{}

function Jeu:init()  -- The constructor
  
  --print("Module / création d'une instance vide de Jeu")
  self.currentLevel = 0
  self.difficulty = 1 -- 1 pour Normal, 0 pour Easy et 2 pour difficult
  self.nbBriquesIncassables = 0
  self.timeElapsed = 0
  self.totalTimeElapsed = 0
end