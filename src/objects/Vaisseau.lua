Vaisseau = Class{}

function Vaisseau:init()  -- The constructor

	--print("Module / création d'une instance vide de Vaisseau")
  self.x = 0
  self.y = 0
  self.image = listImages['vaisseau'].normal
  self.l = self.image:getWidth()
  self.h = self.image:getHeight()
  self.v = 0
end

function Vaisseau:initParameters(difficulty)
  self.x = ECRAN_LARGEUR / 2
  self.y = ECRAN_HAUTEUR - 20
  
  if difficulty == 0 then
    self.v = 4
  elseif difficulty == 1 then
    self.v = 5
  else
    self.v = 6
  end
end

function Vaisseau:resetPosition()
  self.x = ECRAN_LARGEUR / 2
  self.y = ECRAN_HAUTEUR - 20
end

function Vaisseau:updateImage(_image)
  self.image = _image
  self.l = self.image:getWidth()
  self.h = self.image:getHeight()
end

function Vaisseau:updateVitesse(number)
  self.v = self.v + number
end