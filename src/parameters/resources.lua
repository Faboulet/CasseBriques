listFonts={
  ['barcade'] = {},
  ['minecraft'] = {},
  ['arial'] = {},
  ['orbitron'] = {},
  ['hack'] = {}
}

listFonts['barcade'].normal = love.graphics.newFont("assets/fonts/barcade.ttf", 50)
listFonts['minecraft'].small = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 14)
listFonts['minecraft'].normal = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 20)
listFonts['minecraft'].big = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 28)
listFonts['minecraft'].bigger = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 48)
listFonts['minecraft'].biggest = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 64)
listFonts['minecraft'].huge = love.graphics.newFont("assets/fonts/Minecrafter.Reg.ttf", 78)
listFonts['arial'].normal = love.graphics.newFont("assets/fonts/arial.ttf",12)
listFonts['orbitron'].normal = love.graphics.newFont("assets/fonts/orbitron.ttf",15)
listFonts['orbitron'].idle = love.graphics.newFont("assets/fonts/orbitron.ttf",20) 
listFonts['orbitron'].medium = love.graphics.newFont("assets/fonts/orbitron.ttf",24)
listFonts['orbitron'].large = love.graphics.newFont("assets/fonts/orbitron.ttf",40)
listFonts['orbitron'].scoreFont = love.graphics.newFont("assets/fonts/orbitron.ttf",32)
listFonts['orbitron'].huge = love.graphics.newFont("assets/fonts/orbitron.ttf",60)
listFonts['hack'].italic = love.graphics.newFont("assets/fonts/Hack-BoldItalic.ttf",10)

listImages={
  -- Background
  ['BG'] = {},
  -- Limites
  ['limite'] = {},
  -- GUI
  ['vie'] = love.graphics.newImage("assets/images/GUI/heart.png"),
  -- Vaisseau
  ['vaisseau']={},
  -- Menu images
  ['menu'] = {},
  -- Button images
  ['button'] = {},
  -- Item images
  ['item'] = {}
}
local nbBG
for nbBG = 1, 7 do
  listImages['BG'][nbBG] = {}
  listImages['BG'][nbBG].normal = love.graphics.newImage("assets/images/BG/bg"..nbBG..".png")
  listImages['BG'][nbBG].small = love.graphics.newImage("assets/images/BG/bg"..nbBG.."_small.png")
end

-- le background peut être modifié
BACKGROUND_IMAGE = listImages['BG'][1]

listImages['limite'].gauche = love.graphics.newImage("assets/images/BG/limite_gauche.png")
listImages['limite'].droite = love.graphics.newImage("assets/images/BG/limite_droite.png")
listImages['limite'].haute = love.graphics.newImage("assets/images/BG/limite_haute.png")
listImages['vaisseau'].normal = love.graphics.newImage("assets/images/Sprites/vaisseau.png")
listImages['vaisseau'].small = love.graphics.newImage("assets/images/Sprites/vaisseauSmall.png")
listImages['vaisseau'].big = love.graphics.newImage("assets/images/Sprites/vaisseauBig.png")
listImages['vaisseau'].intro = love.graphics.newImage("assets/images/Sprites/vaisseauFlou.png")
listImages['menu'].loadGame = love.graphics.newImage("assets/images/Menu/Load.png")
listImages['menu'].commands = love.graphics.newImage("assets/images/Menu/Commands.png")
listImages['button'].normal = love.graphics.newImage("assets/images/Boutons/Button.png")
listImages['button'].small = love.graphics.newImage("assets/images/Boutons/Button_small.png")
listImages['button'].selected = love.graphics.newImage("assets/images/Boutons/ButtonSelect.png")
listImages['button'].smallSelected = love.graphics.newImage("assets/images/Boutons/ButtonSelect_small.png")
listImages['button'].leftSelect = love.graphics.newImage("assets/images/Boutons/LeftSelect.png")
listImages['button'].rightSelect = love.graphics.newImage("assets/images/Boutons/RightSelect.png")
listImages['button'].option = love.graphics.newImage("assets/images/Boutons/ButtonOption.png")
listImages['button'].optionSelect = love.graphics.newImage("assets/images/Boutons/ButtonOptionSelect.png")
listImages['item'].small = love.graphics.newImage("assets/images/Items/Small.png")
listImages['item'].big = love.graphics.newImage("assets/images/Items/Big.png")
listImages['item'].moreLife = love.graphics.newImage("assets/images/Items/MoreLife.png")
listImages['item'].lessLife = love.graphics.newImage("assets/images/Items/LessLife.png")
listImages['item'].moreSpeed = love.graphics.newImage("assets/images/Items/MoreSpeed.png")
listImages['item'].lessSpeed = love.graphics.newImage("assets/images/Items/LessSpeed.png")

listTileMap = {
  ['briques'] = love.graphics.newImage("assets/images/Tilemap/Briques.png")
}
listSounds = {
    ['sonShoot'] = love.audio.newSource('assets/sounds/shoot.wav','static'),
    ['sonExplode'] = love.audio.newSource('assets/sounds/explode_touch.wav','static'),
    ['music'] = love.audio.newSource('assets/sounds/music.mp3','stream')
}
