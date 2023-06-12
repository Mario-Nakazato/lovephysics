require "/src/palavras" -- Mudar nome
require "/src/camera"
require "/src/mundo"
require "/src/objeto" -- Nome muito generico mudar para ser mais expecifico.

function love.load(arg, unfilteredArg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end -- Debug para ZeroBrane Studio IDE Utilize; Argumento - arg esta disponivel global.

    update = true                                                 -- Executar a função love.update atualizando o argumento dt local e tick global a cada ciclo true/false.
    ticks = 0                                                     -- Soma o tempo decorrido a cada ciclo do tick do argumento dt do love.update.

    slow = 1                                                      -- Criado para debugar, ainda em teste, é util ? feito para acelerar e desacelerar o tempo (Não exagerar nos valores).

    --love.keyboard.setKeyRepeat(true)

    --lgrafico.setBackgroundColor(rgbByte(255,255,255))
    ct, lt = lgrafico.getDimensions() -- Dimensão da tela comprimento e largura.

    offx, offy = 480, 180             -- inicialização da area realmente utilizada "vista".
    --ct, lt = ct -offx, lt -offy -- Antigamente utilizada para definir a area real comprimento e largura. Deletar se não utilizar mais 12/01/2021.

    cam = camera.novo(-offx / 2, -offy / 2)

    terra = mundo.novo(64, 64 * 0, 64 * 9.81)

    z = {} -- Utilizado para criar a dimensão Z, como elemento do 3D, para para organizar qual imagem é desenhada primeira. Isso gera sobreposições.

    terreno = objeto.novo("fill", terra, (ct - offx) / 2, lt - offy + 8, "static", ct * 4 - offx, 16)
    table.insert(z, terreno.draw)

    plataforma = objeto.novo("line", terra, (ct - offx) / 2, lt / 2 + 16, "kinematic", (ct - offx) / 4, 32)
    table.insert(z, plataforma.draw)
    plataforma.getCorpo():setLinearVelocity(64 * 4, 0)

    circulo = objeto.novo("line", terra, 128 * -1, 0, "dynamic", 32)
    table.insert(z, circulo.draw)

    quadrado = objeto.novo("line", terra, 128 * 2, 0, "dynamic", 64, 64)
    table.insert(z, quadrado.draw)

    retangulo = objeto.novo("line", terra, 128 * 3, 0, "dynamic", 128, 64)
    table.insert(z, retangulo.draw)

    triangulo = objeto.novo("line", terra, 128 * 4, 0, "dynamic", 0, 0, 64, 64, 128, 0)
    table.insert(z, triangulo.draw)

    pentagono = objeto.novo("line", terra, 128 * 5, 0, "dynamic", 0, 0, 64, 64, 128, 64, 192, 0, 96, -64)
    table.insert(z, pentagono.draw)

    hexagono = objeto.novo("line", terra, 128 * 6, 0, "dynamic", 0, 0, 64, 64, 128, 64, 192, 0, 128, -64, 64, -64)
    table.insert(z, hexagono.draw)

    heptagono = objeto.novo("line", terra, 128 * 7, 0, "dynamic", 0, 0, 64, 64, 128, 64, 192, 0, 160, -32, 96, -64, 32,
        -32)
    table.insert(z, heptagono.draw)

    octogono = objeto.novo("line", terra, 128 * 8, 0, "dynamic", 0, 0, 16, 48, 64, 64, 128, 64, 192, 0, 128, -64, 64, -64,
        16, -48)
    table.insert(z, octogono.draw)

    cadeira = objeto.novo("line", terra, 128 * -0.5, 256, "static", false, 0, 0, 64, 64, 128, 0)
    table.insert(z, cadeira.draw)

    linha = objeto.novo("fill", terra, 128 * 7, 256, "static", 0, 0, 64, 64)
    table.insert(z, linha.draw)

    distancia = {}
    distancia[1] = objeto.novo("line", terra, 0, 0, "dynamic", 32)
    table.insert(z, distancia[1].draw)

    distancia[2] = objeto.novo("line", terra, 128 * 2, -256, "dynamic", 32)
    table.insert(z, distancia[2].draw)

    jdist = lfisica.newDistanceJoint(distancia[1].getCorpo(), distancia[2].getCorpo(), 0, 0, 256, -256, false)

    atrito = {}
    atrito[1] = objeto.novo("line", terra, 128 * -2, 128, "dynamic", 128, 512)
    table.insert(z, atrito[1].draw)

    atrito[2] = objeto.novo("line", terra, 128 * -2, 0, "dynamic", 32)
    table.insert(z, atrito[2].draw)

    jatri = lfisica.newFrictionJoint(atrito[1].getCorpo(), atrito[2].getCorpo(), 128 * -2, 128, 128 * -2, 0, false)
    jatri:setMaxForce(64 * 9.81 * 2)
end

function love.update(dt)
    if not update then -- Retorna a função para não haver atualizações.
        return
    end

    tick = dt            -- Tornar o argumento dt global.
    ticks = ticks + tick -- Soma os tick de cada ciclo, contando o tempo.

    --[[
  dx, dy = circulo.getCorpo():getPosition()
  cam:seguir(dx, dy)
  --]]

    --Para alterar movimento da plataforma.
    local posx, posy = plataforma.getCorpo():getPosition()
    if posx >= ct - offx - (ct - offx) / 8 then
        plataforma.getCorpo():setLinearVelocity(-64 * 4, 0)
    elseif posx <= (ct - offx) / 8 then
        plataforma.getCorpo():setLinearVelocity(64 * 4, 0)
    end

    --Para alterar movimento da octogono.
    posx, posy = octogono.getCorpo():getPosition()
    if posx >= ct - offx - (ct - offx) / 8 then
        octogono.getCorpo():setLinearVelocity(-64 * 16, 0)
    elseif posx <= (ct - offx) / 8 then
        octogono.getCorpo():setLinearVelocity(64 * 16, 0)
    end

    terra:update(tick / slow)
end

function love.draw()
    --[[

    Configuração padrão
    Utilizado para manter as configurações gerais.
    Talvez não necessario ao final, a regra talvez é cada elemento ter sua propria configuração, e se alterar.

  --]]

    --lgrafico.push("all") -- Empurra toda ("all") configuração para pilha de "draw" existem um desenpilhador "pop". Sempre em pares "push" -> "pop". Para não criar stack over flow.
    lgrafico.setColor(rgbByte({ 255, 255, 255 }))

    --Camera?
    cam:draw()

    for c, v in pairs(z) do -- Faz parte do Z garantir a ideia de terceira dimensão. Seve ser melhorado.
        v()
    end

    --[[

    Debug
    Utilizado para melhor visualização e orientação, no caso do "draw" imagens criada em tela.

  --]]

    --Marcação Teste estatico Uma Cruz com um circulo.
    --[[
  local x, y = lgrafico.inverseTransformPoint(ct -64, lt -64)--Posição da tela para a posição global
  local xt, yt = lgrafico.transformPoint(x, y)--Posição globla para a posição na tela

  lgrafico.setColor(rgbByte({127, 127, 127}))
  lgrafico.line(-32 +x, y, 32 +x, y)
  lgrafico.line(x, -32 +y, x, 32 +y)
  lgrafico.circle("line", x, y, 4)
  lgrafico.setColor(rgbByte({255, 255, 255}))
  lgrafico.print("("..x..", "..y..") Global", 16 +x, 16 +y)
  lgrafico.print("("..xt..", "..yt..") Tela", 16 +x, 16 *2 +y)
  --]]

    --Marcação Teste Dinamico Cruz com um circulo.
    --[[
  local xt, yt = lgrafico.transformPoint(64, 64)--Posição global para a posição na tela
  local x, y = lgrafico.inverseTransformPoint(xt, yt)--Posição da tela para a posição global

  lgrafico.setColor(rgbByte({127, 127, 127}))
  lgrafico.line(-32 +x, y, 32 +x, y)
  lgrafico.line(x, -32 +y, x, 32 +y)
  lgrafico.circle("line", x, y, 4)
  lgrafico.setColor(rgbByte({255, 255, 255}))
  lgrafico.print("("..x..", "..y..") Global", 16 +x, 16 +y)
  lgrafico.print("("..xt..", "..yt..") Tela", 16 +x, 16 *2 +y)
  --]]

    --Marcação Mouse Uma Cruz com um circulo.
    local x, y = lgrafico.inverseTransformPoint(love.mouse.getX(), love.mouse.getY()) -- Posição da tela para a posição global
    local xt, yt = lgrafico.transformPoint(x, y)                                      -- Posição globla para a posição na tela

    lgrafico.setColor(rgbByte({ 127, 127, 127 }))
    lgrafico.line(-32 + x, y, 32 + x, y)
    lgrafico.line(x, -32 + y, x, 32 + y)
    lgrafico.circle("line", x, y, 4)
    lgrafico.setColor(rgbByte({ 255, 255, 255 }))
    lgrafico.print("(" .. x .. ", " .. y .. ") Global", 16 + x, 16 + y)
    lgrafico.print("(" .. xt .. ", " .. yt .. ") Tela", 16 + x, 16 * 2 + y)

    --Marcação Centro da tela Uma Cruz com um circulo.

    local x, y = lgrafico.inverseTransformPoint(ct / 2, lt / 2) -- Posição da tela para a posição global
    local xt, yt = lgrafico.transformPoint(x, y)                -- Posição globla para a posição na tela

    lgrafico.setColor(rgbByte({ 127, 127, 127 }))
    lgrafico.line(-32 + x, y, 32 + x, y)
    lgrafico.line(x, -32 + y, x, 32 + y)
    lgrafico.circle("line", x, y, 4)
    lgrafico.setColor(rgbByte({ 255, 255, 255 }))
    lgrafico.print("(" .. x .. ", " .. y .. ") Global", 16 + x, 16 + y)
    lgrafico.print("(" .. xt .. ", " .. yt .. ") Tela", 16 + x, 16 * 2 + y)

    --Marcação Origem (0, 0) Cruz com um circulo.

    local xt, yt = lgrafico.transformPoint(0, 0)        -- Posição global para a posição na tela
    local x, y = lgrafico.inverseTransformPoint(xt, yt) -- Posição da tela para a posição global

    lgrafico.setColor(rgbByte({ 127, 127, 127 }))
    lgrafico.line(-32 + x, y, 32 + x, y)
    lgrafico.line(x, -32 + y, x, 32 + y)
    lgrafico.circle("line", x, y, 4)
    lgrafico.setColor(rgbByte({ 255, 255, 255 }))
    lgrafico.print("(" .. x .. ", " .. y .. ") Global", 16 + x, 16 + y)
    lgrafico.print("(" .. xt .. ", " .. yt .. ") Tela", 16 + x, 16 * 2 + y)

    --lgrafico.pop() -- Desempilha um "push" no caso de configurações de grafico Sempre em pares "push" -> "pop". Para não criar stack over flow.
end

function love.keypressed(key, scancode, isrepeat)
    if key == "f1" then -- key para ativar ou desativar o love.update.
        update = not update
    end
    if key == "f5" then -- key para reiniciar love.load().
        love.load(arg)
    end

    if key == "return" then
        --circulo.getCorpo():applyLinearImpulse(64*2*slow, 0)
        circulo.getCorpo():setLinearVelocity(-64 * 2 * slow, 0)
        atrito[2].getCorpo():setLinearVelocity(-64 * 2 * slow, 0)
    end

    if key == "kp-" then
        --circulo.getCorpo():setMass(1)
        slow = 1
    end
    if key == "kp+" then
        slow = 60
        --circulo.getCorpo():setMass(1/20)
    end
    if key == "kp*" then
        slow = 0.2
    end
    if key == "kp/" then
        terra:setGravity(0, 0)
    end
    if key == "kp." then -- "key do numerico , "
        terra:setGravity(64 * 0, 64 * 9.81)
    end
end

function love.keyreleased(key, scancode)
end

function love.mousepressed(x, y, button, istouch, presses)
    cam:mouse(button)
end

function love.mousereleased(x, y, button, istouch, presses)
    cam:mouse(button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    cam:mov(dx, dy, 64, tick) -- tick ou valor 1/60. Testar assim não depende do dt do love.update ? .
end

--[[
function love.wheelmoved(x, y)
end

function love.mousefocus(focus)
end

function love.resize(w, h)
end

function love.focus(focus)
end

function love.quit()
end

function love.touchpressed(id, x, y, dx, dy, pressure)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
end

function love.displayrotated(index, orientation)
end

function love.textedited(text, start, length)
end

function love.textinput(text)
end

function love.directorydropped(path)
end

function love.filedropped(file)
end

function love.errorhandler(msg)
end

function love.lowmemory()
end

function love.threaderror(thread, errorstr)
end

function love.visible(visible)-- Esta funcao CallBack não funciona, utilize visivel = love.window.isMinimized()
end

--love.physics world callbacks
function beginContact(a, b, coll)
end

function endContact(a, b, coll)
end

function preSolve(a, b, coll)
end

--postSolve(fixture1, fixture2, contact, normal_impulse1, tangent_impulse1, normal_impulse2, tangent_impulse2)
function postSolve(a, b, coll, normalimpulse, tangentimpulse)
end
--love.physics world callbacks
--]]
