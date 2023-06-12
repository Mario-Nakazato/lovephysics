--[[

  Talvez:
  Criar um metodo para a classe criar os callbacks.

--]]

local function novo(pixelPorMetro, gx, gy)
  
  lfisica.setMeter(pixelPorMetro)
  local classe = lfisica.newWorld(gx, gy, true)
  classe:setCallbacks(inicioContato, fimContato, preContato, posContato) -- Melhorar

  return classe

end

mundo = {
  
  novo = novo
  
}

print("mundo.lua")

return mundo