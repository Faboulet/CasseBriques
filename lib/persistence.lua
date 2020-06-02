local csvFile = require("lib/tinyCSV")
local json = require("lib/json")

-- Separator of CSV File
local sep = ";"

-- Work folder
local saveFolder = love.filesystem.getSaveDirectory().."/"
local saveName = "save.json"
local highscoreName = "highscore.lst"

local persistence = {}

persistence.persistSave = function(save)
  
  local encodedSave = json.encode(save)
  local success, errorString = love.filesystem.write(saveName, encodedSave)
  if not success then
    print("Following error occured with save file "..saveName.." : " .. errorString)
  end
  return success, errorString
end

persistence.fetchSave = function()
  if not love.filesystem.getInfo(saveName) then
    print("Save file does not exist : "..saveName)
    return nil
  end
  return json.decode(love.filesystem.read(saveName))
end

persistence.persistHighscore = function(highscoreTable)
  -- print("Saving highscore to file : "..highscoreName)
  if not love.filesystem.getInfo(highscoreName) then
    print("File does not exist : "..highscoreName)
    love.filesystem.createDirectory(saveFolder)
  end
  csvFile:writeFile(saveFolder..highscoreName, highscoreTable, sep, 2)
end

persistence.fetchHighscore = function()
  if not love.filesystem.getInfo(highscoreName) then
    print("Highscore file does not exist : "..highscoreName)
    return nil
  end
  return csvFile:readFile(saveFolder..highscoreName, sep)
end

return persistence