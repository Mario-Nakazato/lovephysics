--[[
  
  Talvez:
  Criar um metodo para a classe mudar de cor do objeto, no caso do circulo a linha de referencia.
  centralizar poligonos.
  nomes são refencia para callbacks de colicoes.
  Z seria uma dimencao para diferenciar profundidade e preferencia. -- não é ele quem cuida da dimensão desenhar.
  
--]]

local function novo(modo, mundo, cx, cy, tipo, ...) -- modo, mundo, cx, cy, tipo, [Raio] [c, l] [{Pontos} centralizar x y], nome$, cor(rgba)$, nZ$.
  
  local arg = {...}
  
  local atributos = {
    modo = modo,
    corpo = lfisica.newBody(mundo, cx, cy, tipo),
    velocidade = true, -- Deletar.
  }
  
  local metodos = {}
  
  if #arg == 1 then
    
    atributos.forma = lfisica.newCircleShape(...) -- atualmente raio, mas opções x, y, raio.
    
  elseif #arg == 2 then
    
    atributos.forma = lfisica.newRectangleShape(...) -- atualmente largura e altura ou comprimento e largura, mas opções x, y, largura, altura, angulo.
  
  elseif #arg == 4 then
    
    atributos.forma = lfisica.newEdgeShape(...) -- 4 numeros para posição da linha.
  
  elseif type(arg[1]) == "boolean" and #arg >= 6 then -- Max vertices 8.
    
    atributos.forma = lfisica.newChainShape(...) -- type(arg[1]) == "boolean".
    
  elseif #arg >= 6 and #arg <= 16 then -- Max vertices 8.
    
    atributos.forma = lfisica.newPolygonShape(arg) -- Vertices (n). Max vertices 8.
  
  end
  
  atributos.fixar = lfisica.newFixture(atributos.corpo, atributos.forma)
  
  function metodos.getCorpo()
    return atributos.corpo
  end
  
  function metodos.getForma()
    return atributos.forma
  end
  
  function metodos.getFixar()
    return atributos.fixar
  end
  
  function metodos.vel(bol) -- Temporario.
      atributos.velocidade = bol
    end
  
  function metodos:draw()
    
    lgrafico.push("all")
    
    if #arg == 1 then
      
      lgrafico.circle(atributos.modo, atributos.corpo:getX(), atributos.corpo:getY(), atributos.forma:getRadius())
      
      lgrafico.setColor(rgbByte(255, 255, 255))
      lgrafico.line(atributos.corpo:getX(), atributos.corpo:getY(), atributos.corpo:getX() +atributos.forma:getRadius()*math.cos(atributos.corpo:getAngle()), atributos.corpo:getY() +atributos.forma:getRadius()*math.sin(atributos.corpo:getAngle()))
      
    else
      
      if #arg == 4 or arg[1] == false or modo == "line" and type(arg[1]) == "boolean" then -- Resolve o desenha para linha e cadeira.
        
        lgrafico.line(atributos.corpo:getWorldPoints(atributos.forma:getPoints()))
        
      else
        
        lgrafico.polygon(atributos.modo, atributos.corpo:getWorldPoints(atributos.forma:getPoints()))
      
      end
      
    end
    
    if atributos.velocidade then -- Temporario.
      local vx, vy = atributos.corpo:getLinearVelocity()
      lgrafico.print("("..vx..", "..vy..")", atributos.corpo:getX(), atributos.corpo:getY())
    end
    
    lgrafico.pop()
    
  end
  
  return metodos
  
end

objeto = {
  
  novo = novo,
  
}

print("objeto.lua")

return objeto