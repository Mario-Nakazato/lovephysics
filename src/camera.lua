--[[

  Posição por enquanto no canto superior esquerdo
  ?Mudar para o centro?

--]]

local function novo(x, y, escala)
  
  local classe = {
    x = x or 0,
    y = y or 0,
    escala = escala or 1,
    mover = false,
  }
  
  function classe:draw()
    love.graphics.translate(-self.x, -self.y)
    love.graphics.scale(self.escala)
  end
  
  function classe:mouse(botao)
    
    if botao == 1 then
      self.mover = not self.mover
    end
    
  end
  
  function classe:mov(dx, dy, pixelPorMetro, dt)
    if self.mover then
      self.x = self.x -dx *pixelPorMetro *(dt or 0)
      self.y = self.y -dy *pixelPorMetro *(dt or 0)
    end
  end
  
  function classe:seguir(dx, dy) -- ? Arrumar
    self.x = dx -ct /2
    self.y = dy -lt /2
  end

  return classe

end

camera = {
  
  novo = novo
  
}

print("camera.lua")

return camera