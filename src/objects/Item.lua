Item = Class{}

function Item:init(posX, posY, _indiceImage) -- The constructor
  --print("Module / création d'une instance de Item")
  self.x = posX
  self.y = posY
  self.image = _indiceImage
end