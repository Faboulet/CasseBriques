Brique = Class{}

function Brique:init(posX, posY, _indiceImage, _largeur, _hauteur, _destroy, _life, _move)  -- The constructor

	--print("Module / création d'une instance de Brique")
  self.x = posX
  self.y = posY
  self.vie = _life
  self.infini = _destroy
  self.move = _move
  self.indiceImage = _indiceImage
  self.l = _largeur
  self.h = _hauteur
end