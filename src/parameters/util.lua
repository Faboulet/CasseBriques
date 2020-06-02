function formatTime(time)
  local minFormat
  local secFormat
  if math.floor(time / 60) < 10 then
    minFormat = "0"..math.floor(time / 60)
  else
    minFormat = math.floor(time / 60)
  end
  if math.floor(time % 60) < 10 then
    secFormat = "0"..math.floor(time % 60)
  else
    secFormat = math.floor(time % 60)
  end
  return minFormat..":"..secFormat
end