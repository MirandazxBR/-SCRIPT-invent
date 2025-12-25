CLIENT.lua

local screenW, screenH = guiGetScreenSize()
local resW, resH = 1366, 768 
local x, y = screenW/resW, screenH/resH
local f = (screenW/resW + screenH/resH) / 2

-- CONFIGURAÇÃO DE CORES
local corDestaque = tocolor(255, 204, 0, 255) 
local corFundoPrincipal = tocolor(0, 0, 0, 245)
local corItemPadrao = tocolor(255, 255, 255, 5)
local corLateral = tocolor(15, 15, 15, 255)
local corBotaoInativo = tocolor(30, 30, 30, 150)

-- VARIÁVEIS DE CONTROLE
local info = { 
    exibindo = false, 
    pesoAtual = 18.5, 
    pesoMax = 30.0,
    menuContexto = nil,
    itemSegurado = nil,
    confirmacao = nil, 
    tooltip = nil,
    scroll = 0,
    maxItensVisiveis = 7,
    categoriaAtual = "TODOS",
    animAlpha = 0 
}

-- CATEGORIAS
local categorias = {
    "TODOS", "ARMAS", "MUNIÇÕES", "COMIDA E BEBIDA", "SAÚDE", "EQUIPAMENTOS", "OUTROS"
}

-- INPUT DE QUANTIDADE
local editQtd = guiCreateEdit(-100, -100, 0, 0, "", false)
guiSetVisible(editQtd, false)
guiEditSetMaxLength(editQtd, 5)

-- TABELA DE ITENS (Atualizada com Durabilidade e Vida Útil)
local itensInv = {
    {nome = "AK-47", qtd = 1, cat = "ARMAS", img = "assets/ak47.png", peso = 4.5, desc = "Rifle de assalto de alto calibre. Perde precisão ao quebrar.", durabilidade = 85},
    {nome = "7.62mm", qtd = 90, cat = "MUNIÇÕES", img = "assets/ammo.png", peso = 0.01, desc = "Munição para rifles."},
    {nome = "Pão", qtd = 5, cat = "COMIDA E BEBIDA", img = "assets/pao.png", peso = 0.1, desc = "Restaura fome e vida. Consuma antes que apodreça.", vida_util = 90},
    {nome = "COCA-COLA", qtd = 2, cat = "COMIDA E BEBIDA", img = "assets/coca.png", peso = 0.3, desc = "Mata a sede rapidamente.", vida_util = 100},
    {nome = "KIT MÉDICO", qtd = 1, cat = "SAÚDE", img = "assets/medkit.png", peso = 1.0, desc = "Kit de primeiros socorros.", durabilidade = 100},
    {nome = "Bandagem", qtd = 10, cat = "SAÚDE", img = "assets/bandagem.png", peso = 0.1, desc = "Cura sangramentos leve."},
}

-- VARIÁVEIS DA HOTBAR
local hotbar = { [1] = nil, [2] = nil, [3] = nil, [4] = nil, [5] = nil }
local hbAnim = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0 } -- Controla o brilho/pulso ao usar

-- FUNÇÕES AUXILIARES
function isMouseInPosition(x, y, w, h)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    mx, my = mx * screenW, my * screenH
    return (mx >= x and mx <= x + w) and (my >= y and my <= y + h)
end

function dxDrawRoundedRectangle(x, y, w, h, radius, color)
    dxDrawRectangle(x + radius, y, w - radius * 2, h, color)
    dxDrawRectangle(x, y + radius, w, h - radius * 2, color)
    dxDrawCircle(x + radius, y + radius, radius, 180, 270, color)
    dxDrawCircle(x + w - radius, y + radius, radius, 270, 360, color)
    dxDrawCircle(x + radius, y + h - radius, radius, 90, 180, color)
    dxDrawCircle(x + w - radius, y + h - radius, radius, 0, 90, color)
end

local function getIconPath(nome)
    for _, item in ipairs(itensInv) do
        if item.nome == nome then
            return item.img
        end
    end
    return nil
end

local function getItemData(nome)
    for _, item in ipairs(itensInv) do
        if item.nome == nome then
            return item
        end
    end
    return nil
end

-- RENDERIZAÇÃO
function renderInventarioUltra()
    if not info.exibindo then return end

    if info.animAlpha < 255 then info.animAlpha = math.min(info.animAlpha + 15, 255) end
    local alphaMult = info.animAlpha / 255

    local pW, pH = 520*x, 480*y
    local pX, pY = (screenW - pW) / 2, (screenH - pH) / 2
    
    local corFundoFade = tocolor(0, 0, 0, 245 * alphaMult)
    local corLatFade = tocolor(15, 15, 15, 255 * alphaMult)
    local corTxtFade = tocolor(255, 255, 255, 255 * alphaMult)
    local corDestaqueFade = tocolor(255, 204, 0, 255 * alphaMult)

    dxDrawRoundedRectangle(pX, pY, pW, pH, 15, corFundoFade)
    dxDrawRectangle(pX, pY, 150*x, pH, corLatFade) 
    dxDrawRectangle(pX + 149*x, pY, 1*x, pH, tocolor(255, 255, 255, 10 * alphaMult))
    
    dxDrawText("INVENTARIO", pX, pY + 20*y, pX + 150*x, nil, tocolor(255,255,255, 100 * alphaMult), 0.8*f, "default-bold", "center")

    for i, cat in ipairs(categorias) do
        local bX, bY = pX + 10*x, pY + 50*y + (i-1) * 38*y
        local bW, bH = 130*x, 32*y
        local isSelected = (info.categoriaAtual == cat)
        local isHover = isMouseInPosition(bX, bY, bW, bH)
        
        local corBtn = isSelected and corDestaqueFade or (isHover and tocolor(60, 60, 60, 200 * alphaMult) or tocolor(30, 30, 30, 150 * alphaMult))
        dxDrawRoundedRectangle(bX, bY, bW, bH, 8, corBtn)
        
        local corTxtBtn = isSelected and tocolor(0, 0, 0, 255 * alphaMult) or (isHover and corTxtFade or tocolor(100, 100, 100, 255 * alphaMult))
        dxDrawText(cat, bX, bY, bX + bW, bY + bH, corTxtBtn, 0.75*f, "default-bold", "center", "center")
    end

    local mX, mY = pX + 15*x, pY + pH - 70*y
    local barW, barH = 120*x, 10*y
    local porc = info.pesoAtual / info.pesoMax
    local r, g, b = 50, 255, 50
    if porc >= 0.5 and porc < 0.85 then r, g, b = 255, 204, 0 elseif porc >= 0.85 then r, g, b = 255, 50, 50 end

    if fileExists("assets/backpack.png") then
        dxDrawImage(mX, mY + 2*y, 22*x, 22*y, "assets/backpack.png", 0, 0, 0, tocolor(r, g, b, 200 * alphaMult))
    else
        dxDrawText("🎒", mX, mY, nil, nil, tocolor(r, g, b, 150 * alphaMult), 1.1*f)
    end
    dxDrawText(string.format("%.1f", info.pesoAtual).."#888888 / "..info.pesoMax.."kg", mX + 28*x, mY + 8*y, nil, nil, corTxtFade, 0.75*f, "default-bold", "left", "top", false, false, false, true)
    dxDrawRectangle(mX, mY + 30*y, barW, barH, tocolor(255, 255, 255, 30 * alphaMult))
    dxDrawRectangle(mX + 2, mY + 32*y, (barW - 4) * porc, barH - 4, tocolor(r, g, b, 180 * alphaMult))

    info.tooltip = nil
    local exibidos, filtrados, totalFiltrados = 0, 0, 0
    
    for _, item in ipairs(itensInv) do
        if info.categoriaAtual == "TODOS" or item.cat == info.categoriaAtual then
            totalFiltrados = totalFiltrados + 1
        end
    end

    for i, item in ipairs(itensInv) do
        if info.categoriaAtual == "TODOS" or item.cat == info.categoriaAtual then
            filtrados = filtrados + 1
            if filtrados > info.scroll and exibidos < info.maxItensVisiveis then
                exibidos = exibidos + 1
                local itemY = pY + 30*y + (exibidos-1) * 58*y
                local itemX = pX + 170*x
                
                local isHover = not info.menuContexto and isMouseInPosition(itemX, itemY, 330*x, 52*y)
                
                if isHover then
                    dxDrawRoundedRectangle(itemX - 1, itemY - 1, 332*x, 54*y, 9, tocolor(255, 255, 255, 15 * alphaMult)) 
                    dxDrawRoundedRectangle(itemX, itemY, 330*x, 52*y, 8, tocolor(255, 255, 255, 20 * alphaMult))
                    info.tooltip = {item = item, index = i}
                else
                    dxDrawRoundedRectangle(itemX, itemY, 330*x, 52*y, 8, tocolor(255, 255, 255, 5 * alphaMult))
                end

                if item.img and fileExists(item.img) then
                    dxDrawImage(itemX + 12*x, itemY + 11*y, 30*x, 30*y, item.img, 0, 0, 0, isHover and tocolor(255,255,255, 255 * alphaMult) or tocolor(255,255,255, 180 * alphaMult))
                end
                
                dxDrawText(item.nome, itemX + 55*x, itemY + 10*y, nil, nil, isHover and corDestaqueFade or corTxtFade, 0.95*f, "default-bold")
                
                -- LÓGICA DA BARRINHA DE ESTADO (DURABILIDADE/VIDA ÚTIL) NO INVENTÁRIO
                local valStatus = item.durabilidade or item.vida_util
                if valStatus then
                    local barInvW = 60*x
                    local rS, gS, bS = 50, 255, 50
                    if valStatus < 30 then rS, gS, bS = 255, 50, 50 elseif valStatus < 70 then rS, gS, bS = 255, 204, 0 end
                    dxDrawRectangle(itemX + 55*x, itemY + 32*y, barInvW, 4*y, tocolor(255, 255, 255, 20 * alphaMult))
                    dxDrawRectangle(itemX + 55*x, itemY + 32*y, barInvW * (valStatus/100), 4*y, tocolor(rS, gS, bS, 180 * alphaMult))
                    dxDrawText(item.peso.."kg", itemX + 55*x, itemY + 38*y, nil, nil, tocolor(100, 100, 100, 255 * alphaMult), 0.7*f, "default-bold")
                else
                    dxDrawText(item.peso.."kg", itemX + 55*x, itemY + 28*y, nil, nil, tocolor(100, 100, 100, 255 * alphaMult), 0.75*f, "default-bold")
                end

                dxDrawText(item.qtd.."x", itemX + 280*x, itemY, itemX + 320*x, itemY + 52*y, corDestaqueFade, 1.1*f, "default-bold", "right", "center")
            end
        end
    end

    if totalFiltrados > info.maxItensVisiveis then
        local barAreaX, barAreaY = pX + 505*x, pY + 30*y
        local barAreaH = (info.maxItensVisiveis * 58*y) - 6*y
        dxDrawRectangle(barAreaX, barAreaY, 4*x, barAreaH, tocolor(255, 255, 255, 15 * alphaMult))
        local puxadorH = barAreaH * (info.maxItensVisiveis / totalFiltrados)
        local puxadorY = barAreaY + (info.scroll / (totalFiltrados - info.maxItensVisiveis)) * (barAreaH - puxadorH)
        dxDrawRectangle(barAreaX, puxadorY, 4*x, puxadorH, corDestaqueFade)
    end

    if info.itemSegurado then
        local mx, my = getCursorPosition()
        mx, my = mx * screenW, my * screenH
        if info.itemSegurado.img and fileExists(info.itemSegurado.img) then
            dxDrawImage(mx - 15*x, my - 15*y, 30*x, 30*y, info.itemSegurado.img, 0, 0, 0, tocolor(255,255,255, 200 * alphaMult))
        end
    end

    if info.menuContexto then
        local m = info.menuContexto
        local item = itensInv[m.itemIndex]
        local isArma = (item.cat == "ARMAS")
        local menuH = isArma and 90*y or 60*y

        dxDrawRectangle(m.x, m.y, 120*x, menuH, tocolor(25, 25, 25, 255 * alphaMult))
        dxDrawRectangle(m.x, m.y, 2*x, menuH, corDestaqueFade)

        local hUsar = isMouseInPosition(m.x, m.y, 120*x, 30*y)
        local hDesequipar = isArma and isMouseInPosition(m.x, m.y + 30*y, 120*x, 30*y)
        local descYPos = isArma and 60*y or 30*y
        local hDescartar = isMouseInPosition(m.x, m.y + descYPos, 120*x, 30*y)

        if hUsar then dxDrawRectangle(m.x, m.y, 120*x, 30*y, tocolor(255, 255, 255, 20 * alphaMult)) end
        dxDrawText("USAR", m.x, m.y, m.x + 120*x, m.y + 30*y, hUsar and corDestaqueFade or tocolor(255,255,255, 255 * alphaMult), 0.9*f, "default-bold", "center", "center")
        
        if isArma then
            if hDesequipar then dxDrawRectangle(m.x, m.y + 30*y, 120*x, 30*y, tocolor(255, 255, 255, 20 * alphaMult)) end
            dxDrawText("DESEQUIPAR", m.x, m.y + 30*y, m.x + 120*x, m.y + 60*y, hDesequipar and corDestaqueFade or tocolor(200, 200, 200, 255 * alphaMult), 0.9*f, "default-bold", "center", "center")
        end

        if hDescartar then dxDrawRectangle(m.x, m.y + descYPos, 120*x, 30*y, tocolor(255, 50, 50, 40 * alphaMult)) end
        dxDrawText("DESCARTAR", m.x, m.y + descYPos, m.x + 120*x, m.y + descYPos + 30*y, tocolor(255, 50, 50, 255 * alphaMult), 0.9*f, "default-bold", "center", "center")
    end

    if info.tooltip and not info.itemSegurado and not info.menuContexto then
        local mx, my = getCursorPosition()
        mx, my = mx * screenW + 15, my * screenH + 15
        dxDrawRoundedRectangle(mx, my, 200*x, 80*y, 10, tocolor(0, 0, 0, 230 * alphaMult))
        dxDrawText(info.tooltip.item.nome, mx+10*x, my+10*y, nil, nil, corDestaqueFade, 0.9*f, "default-bold")
        dxDrawText(info.tooltip.item.desc, mx+10*x, my+32*y, mx+190*x, nil, tocolor(180, 180, 180, 255 * alphaMult), 0.8*f, "default-bold", "left", "top", false, true)
    end

    if info.confirmacao then
        local qW, qH = 240*x, 110*y
        local qX, qY = (screenW - qW)/2, (screenH - qH)/2
        dxDrawRoundedRectangle(qX, qY, qW, qH, 15, tocolor(10, 10, 10, 255 * alphaMult))
        dxDrawRectangle(qX + 40*x, qY + 75*y, qW - 80*x, 1*y, corDestaqueFade)
        dxDrawText("QUANTIDADE", qX, qY + 20*y, qX + qW, nil, tocolor(255,255,255, 255 * alphaMult), 1*f, "default-bold", "center")
        dxDrawText(guiGetText(editQtd).."|", qX, qY + 45*y, qX + qW, qY + 75*y, corDestaqueFade, 1.2*f, "default-bold", "center", "center")
    end
end
addEventHandler("onClientRender", root, renderInventarioUltra)

-- INTERAÇÕES (CLICK)
addEventHandler("onClientClick", root, function(button, state)
    if not info.exibindo or info.confirmacao then return end
    local pW, pH = 520*x, 480*y
    local pX, pY = (screenW - pW) / 2, (screenH - pH) / 2

    if state == "down" then
        for i, cat in ipairs(categorias) do
            local bX, bY = pX + 10*x, pY + 50*y + (i-1) * 38*y
            local bW, bH = 130*x, 32*y
            if isMouseInPosition(bX, bY, bW, bH) then
                info.categoriaAtual = cat
                info.scroll = 0
                info.animAlpha = 0
                playSoundFrontEnd(1) 
                return
            end
        end
        if button == "right" and info.tooltip then
            local mx, my = getCursorPosition()
            info.menuContexto = { x = mx * screenW, y = my * screenH, itemIndex = info.tooltip.index }
            playSoundFrontEnd(40) 
        elseif button == "left" then
            if info.menuContexto then
                local m = info.menuContexto
                local item = itensInv[m.itemIndex]
                local isArma = (item.cat == "ARMAS")

                if isMouseInPosition(m.x, m.y, 120*x, 30*y) then
                    triggerServerEvent("inventario:usarItem", localPlayer, item.nome)
                    info.menuContexto = nil
                    playSoundFrontEnd(40)
                elseif isArma and isMouseInPosition(m.x, m.y + 30*y, 120*x, 30*y) then
                    triggerServerEvent("inventario:desequiparArma", localPlayer, item.nome)
                    info.menuContexto = nil
                    playSoundFrontEnd(40)
                elseif isMouseInPosition(m.x, m.y + (isArma and 60*y or 30*y), 120*x, 30*y) then
                    info.confirmacao = { itemIndex = m.itemIndex, acao = "DESCARTADO" }
                    guiSetVisible(editQtd, true)
                    guiSetText(editQtd, "")
                    guiFocus(editQtd)
                    info.menuContexto = nil
                    playSoundFrontEnd(40)
                else
                    info.menuContexto = nil
                end
            elseif info.tooltip then
                info.itemSegurado = { index = info.tooltip.index, img = info.tooltip.item.img }
                playSoundFrontEnd(40)
            end
        end
    elseif state == "up" and button == "left" and info.itemSegurado then
        if not isMouseInPosition(pX, pY, pW, pH) then
            info.confirmacao = { itemIndex = info.itemSegurado.index, acao = "DROPOU" }
            guiSetVisible(editQtd, true)
            guiSetText(editQtd, "")
            guiFocus(editQtd)
            playSoundFrontEnd(40)
        end
        info.itemSegurado = nil
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    if not info.exibindo or not press then return end
    
    local totalFiltrados = 0
    for _, item in ipairs(itensInv) do
        if info.categoriaAtual == "TODOS" or item.cat == info.categoriaAtual then
            totalFiltrados = totalFiltrados + 1
        end
    end

    if button == "mouse_wheel_up" then
        if info.scroll > 0 then 
            info.scroll = info.scroll - 1 
            playSoundFrontEnd(41) 
        end
    elseif button == "mouse_wheel_down" then
        if totalFiltrados > info.maxItensVisiveis then
            if info.scroll < (totalFiltrados - info.maxItensVisiveis) then
                info.scroll = info.scroll + 1
                playSoundFrontEnd(41)
            end
        end
    elseif info.confirmacao then
        if button == "enter" then
            local qtdDigitada = tonumber(guiGetText(editQtd))
            local itemData = itensInv[info.confirmacao.itemIndex]
            
            if qtdDigitada and qtdDigitada > 0 and qtdDigitada <= itemData.qtd then
                if info.confirmacao.acao == "DESCARTADO" then
                    triggerServerEvent("inventario:descartarItem", localPlayer, itemData.nome, qtdDigitada)
                else
                    triggerServerEvent("inventario:droparItemChao", localPlayer, itemData.nome, qtdDigitada)
                end
            else
                outputChatBox("#FF0000[INV] #FFFFFFQuantidade insuficiente ou inválida.", 255, 255, 255, true)
            end

            info.confirmacao = nil
            guiSetVisible(editQtd, false)
            playSoundFrontEnd(40)
        elseif button == "escape" then
            info.confirmacao = nil
            guiSetVisible(editQtd, false)
            playSoundFrontEnd(2)
        end
    end
end)

bindKey("i", "down", function()
    info.exibindo = not info.exibindo
    showCursor(info.exibindo)
    
    if info.exibindo then
        info.animAlpha = 0 
        if fileExists("assets/abrir.mp3") then
            playSound("assets/abrir.mp3") 
        end
    else
        guiSetVisible(editQtd, false) 
        info.menuContexto = nil
        info.itemSegurado = nil
        if fileExists("assets/fechar.mp3") then
            playSound("assets/fechar.mp3")
        end
    end
end)

addEvent("inventario:removerItemClient", true)
addEventHandler("inventario:removerItemClient", root, function(nomeItem)
    for i, item in ipairs(itensInv) do
        if item.nome == nomeItem then
            if item.qtd > 1 then
                item.qtd = item.qtd - 1
            else
                table.remove(itensInv, i)
            end
            break
        end
    end
end)

addEvent("inventario:removerQtdEspecifica", true)
addEventHandler("inventario:removerQtdEspecifica", root, function(nomeItem, quantidade)
    for i, item in ipairs(itensInv) do
        if item.nome == nomeItem then
            if item.qtd > quantidade then
                item.qtd = item.qtd - quantidade
            else
                table.remove(itensInv, i)
            end
            break
        end
    end
end)

addEvent("inventario:tocarSom3D", true)
addEventHandler("inventario:tocarSom3D", root, function(jogadorAlvo, tipo)
    if isElement(jogadorAlvo) then
        local px, py, pz = getElementPosition(jogadorAlvo)
        local path = "assets/sounds/" .. tipo .. ".mp3"
        if fileExists(path) then
            local som = playSound3D(path, px, py, pz)
            setSoundMaxDistance(som, 20)
        end
    end
end)

-- HOTBAR LOGIC
addEventHandler("onClientKey", root, function(button, press)
    if not info.exibindo or not press or info.confirmacao then return end
    local slot = tonumber(button)
    if slot and slot >= 1 and slot <= 5 then
        if info.tooltip then 
            hotbar[slot] = info.tooltip.item.nome
            outputChatBox("#FFFF00[HOTBAR] #FFFFFFItem #FFCC00" .. hotbar[slot] .. " #FFFFFFvinculado ao slot " .. slot .. ".", 255, 255, 255, true)
            playSoundFrontEnd(42)
        end
    end
end)

bindKey("1", "down", function() usarItemHotbar(1) end)
bindKey("2", "down", function() usarItemHotbar(2) end)
bindKey("3", "down", function() usarItemHotbar(3) end)
bindKey("4", "down", function() usarItemHotbar(4) end)
bindKey("5", "down", function() usarItemHotbar(5) end)

function usarItemHotbar(slot)
    if info.exibindo then return end 
    local nomeItem = hotbar[slot]
    if nomeItem then
        local possuiItem = false
        for _, item in ipairs(itensInv) do
            if item.nome == nomeItem then
                possuiItem = true
                break
            end
        end
        if possuiItem then
            hbAnim[slot] = 255 -- Ativa o brilho/animação
            triggerServerEvent("inventario:usarItem", localPlayer, nomeItem)
        else
            outputChatBox("#FF0000[HOTBAR] #FFFFFFVocê não possui mais o item: " .. nomeItem, 255, 255, 255, true)
            hotbar[slot] = nil
        end
    end
end

-- RENDERIZAÇÃO DA HOTBAR COM EFEITOS E BARRAS DE ESTADO
addEventHandler("onClientRender", root, function()
    if info.exibindo then return end 

    local qtdSlots = 5
    local slotBaseSize = 60 * f
    local gap = 12 * x
    local totalW = (slotBaseSize * qtdSlots) + (gap * (qtdSlots - 1))
    local hbX, hbY = (screenW - totalW) / 2, screenH - (slotBaseSize + 30 * y)
    
    for i = 1, qtdSlots do
        if hbAnim[i] > 0 then hbAnim[i] = math.max(hbAnim[i] - 10, 0) end
        
        local sX = hbX + (i-1) * (slotBaseSize + gap)
        local isHover = isMouseInPosition(sX, hbY, slotBaseSize, slotBaseSize)
        
        local sizeAdd = isHover and 5*f or (hbAnim[i]/255 * 8*f)
        local currentSize = slotBaseSize + sizeAdd
        local drawX, drawY = sX - sizeAdd/2, hbY - sizeAdd/2

        dxDrawRoundedRectangle(drawX, drawY, currentSize, currentSize, 10, tocolor(0, 0, 0, 200))
        
        if hbAnim[i] > 0 then
            dxDrawRoundedRectangle(drawX, drawY, currentSize, currentSize, 10, tocolor(255, 204, 0, hbAnim[i] * 0.4))
        end

        local bordaCor = isHover and tocolor(255, 204, 0, 200) or tocolor(255, 255, 255, 40)
        dxDrawRoundedRectangle(drawX, drawY, currentSize, currentSize, 10, bordaCor)
        dxDrawRoundedRectangle(drawX+1, drawY+1, currentSize-2, currentSize-2, 9, tocolor(0, 0, 0, 240))

        dxDrawText(i, drawX + 6, drawY + 4, nil, nil, tocolor(255, 255, 255, 100), 0.7 * f, "default-bold")
        
        if hotbar[i] then
            local itemData = getItemData(hotbar[i])
            if itemData then
                local imgPath = itemData.img
                local imgAlpha = isHover and 255 or 200
                if imgPath and fileExists(imgPath) then
                    dxDrawImage(drawX + 12*f, drawY + 12*f, currentSize - 24*f, currentSize - 24*f, imgPath, 0, 0, 0, tocolor(255, 255, 255, imgAlpha))
                else
                    dxDrawText(hotbar[i], drawX, drawY, drawX + currentSize, drawY + currentSize, tocolor(255, 255, 255, 150), 0.5 * f, "default-bold", "center", "center", true)
                end

                -- BARRINHA DE ESTADO NA HOTBAR
                local valStatus = itemData.durabilidade or itemData.vida_util
                if valStatus then
                    local barHBW = currentSize - 20*f
                    local rS, gS, bS = 50, 255, 50
                    if valStatus < 30 then rS, gS, bS = 255, 50, 50 elseif valStatus < 70 then rS, gS, bS = 255, 204, 0 end
                    dxDrawRectangle(drawX + 10*f, drawY + currentSize - 8*y, barHBW, 3*y, tocolor(0, 0, 0, 200))
                    dxDrawRectangle(drawX + 10*f, drawY + currentSize - 8*y, barHBW * (valStatus/100), 3*y, tocolor(rS, gS, bS, 255))
                end
            end
        end
    end
end)

-- LÓGICA DE GASTO DE DURABILIDADE AO ATIRAR
addEventHandler("onClientPlayerWeaponFire", localPlayer, function()
    for i=1, 5 do
        local nome = hotbar[i]
        if nome then
            local item = getItemData(nome)
            if item and item.cat == "ARMAS" and item.durabilidade then
                item.durabilidade = math.max(0, item.durabilidade - 0.1)
            end
        end
    end
end)

-- TIMER DE DECOMPOSIÇÃO (A cada 60 segundos)
setTimer(function()
    for _, item in ipairs(itensInv) do
        if item.vida_util then
            item.vida_util = math.max(0, item.vida_util - 1)
            if item.vida_util == 0 and item.nome ~= "Comida Estragada" then
                item.nome = "Comida Estragada"
                item.desc = "A comida apodreceu e pode fazer mal."
            end
        end
    end
end, 60000, 0)

-- SINCRONIZAÇÃO COM O SERVIDOR (PARA O PESO E ITENS ATUALIZAREM)
addEvent("inventario:atualizarItens", true)
addEventHandler("inventario:atualizarItens", root, function(novaTabela)
    itensInv = novaTabela
    local total = 0
    for _, item in ipairs(itensInv) do
        total = total + (item.peso * (item.qtd or 1))
    end
    info.pesoAtual = total
end)

-- TRAVA DE CONTROLE (IMPEDE ATIRAR COM O MENU ABERTO)
addEventHandler("onClientPreRender", root, function()
    if info.exibindo or info.confirmacao then
        disableControlAction("fire", true)
        disableControlAction("aim_weapon", true)
        disableControlAction("jump", true)
        disableControlAction("next_weapon", true)
        disableControlAction("previous_weapon", true)
    end
end)
-- ==========================================================
-- FUNÇÕES DE SUPORTE (CLIENT-SIDE)
-- ==========================================================

-- Remove o item completamente da tabela quando acabar
addEvent("inventario:removerItemClient", true)
addEventHandler("inventario:removerItemClient", root, function(nomeItem)
    for i, item in ipairs(itensInv) do
        if item.nome == nomeItem then
            if item.qtd > 1 then
                item.qtd = item.qtd - 1
            else
                table.remove(itensInv, i)
            end
            break
        end
    end
end)

-- Remove uma quantidade específica (usado no Descartar)
addEvent("inventario:removerQtdEspecifica", true)
addEventHandler("inventario:removerQtdEspecifica", root, function(nomeItem, qtdARemover)
    for i, item in ipairs(itensInv) do
        if item.nome == nomeItem then
            if item.qtd > qtdARemover then
                item.qtd = item.qtd - qtdARemover
            else
                table.remove(itensInv, i)
            end
            break
        end
    end
end)

-- Toca os sons para os jogadores próximos
addEvent("inventario:tocarSom3D", true)
addEventHandler("inventario:tocarSom3D", root, function(player, tipo)
    if isElement(player) then
        local px, py, pz = getElementPosition(player)
        local somPath = "assets/sounds/"..tipo..".mp3" -- Certifique-se de ter os sons na pasta
        if fileExists(somPath) then
            local som = playSound3D(somPath, px, py, pz)
            setSoundMaxDistance(som, 20)
        end
    end
end)

server.lua

-- server.lua

-- TABELA DE AÇÕES E ANIMAÇÕES
local acoesItens = {
    ["AK-47"] = function(player)
        if getPedWeapon(player) == 30 then 
            takeWeapon(player, 30)
            triggerClientEvent(root, "inventario:tocarSom3D", player, player, "desequipar")
            outputChatBox("#FFFF00[INV] #FFFFFFVocê guardou sua AK-47.", player, 255, 255, 255, true)
            return false
        else
            setPedAnimation(player, "COLT45", "sawnoff_reload", 1000, false, false, false, false)
            triggerClientEvent(root, "inventario:tocarSom3D", player, player, "equipar")
            setTimer(function()
                giveWeapon(player, 30, 90, true)
                outputChatBox("#FFFF00[INV] #FFFFFFVocê equipou sua AK-47.", player, 255, 255, 255, true)
            end, 1000, 1)
            return false
        end
    end,

    ["Kit Medico"] = function(player)
        setPedAnimation(player, "BOMBER", "BOM_Plant", 2000, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "medkit")
        setTimer(function()
            setElementHealth(player, 100)
            outputChatBox("#00FF00[INV] #FFFFFFVocê usou um Kit Médico.", player, 255, 255, 255, true)
        end, 2000, 1)
        return true
    end,

    ["Bandedi"] = function(player)
        setPedAnimation(player, "GANGS", "prp_pack_bind", 2000, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "bandagem")
        setTimer(function()
            local vidaAtual = getElementHealth(player)
            setElementHealth(player, math.min(vidaAtual + 15, 100))
            outputChatBox("#00FF00[INV] #FFFFFFVocê usou um Bandedi.", player, 255, 255, 255, true)
        end, 2000, 1)
        return true
    end,

    ["Dipirona"] = function(player)
        setPedAnimation(player, "VENDING", "VEND_Drink2_P", 1000, false, false, false, false)
        setTimer(function()
            local vida = getElementHealth(player)
            local doenca = getElementData(player, "disease") or 0
            setElementHealth(player, math.min(vida + 10, 100))
            setElementData(player, "disease", math.max(doenca - 20, 0))
            outputChatBox("#00FF00[INV] #FFFFFFVocê tomou uma Dipirona.", player, 255, 255, 255, true)
        end, 1000, 1)
        return true
    end,

    ["Dorflex"] = function(player)
        setPedAnimation(player, "VENDING", "VEND_Drink2_P", 1000, false, false, false, false)
        local curaPositiva = 40
        local vidaAnterior = getElementHealth(player)
        setElementHealth(player, math.min(vidaAnterior + curaPositiva, 100))
        outputChatBox("#FFFF00[INV] #FFFFFFEfeito analgésico ativo por 1 minuto.", player, 255, 255, 255, true)
        setTimer(function()
            if isElement(player) then
                local vidaAtual = getElementHealth(player)
                setElementHealth(player, math.max(vidaAtual - curaPositiva, 10))
                outputChatBox("#FF0000[INV] #FFFFFFO efeito do Dorflex passou e a dor voltou.", player, 255, 255, 255, true)
            end
        end, 60000, 1)
        return true
    end,

    ["Vacina Inovex"] = function(player)
        setPedAnimation(player, "GANGS", "prp_pack_bind", 2000, false, false, false, false)
        setTimer(function()
            setElementData(player, "disease", 0)
            outputChatBox("#00FF00[INV] #FFFFFFVacina aplicada. Doenças curadas.", player, 255, 255, 255, true)
        end, 2000, 1)
        return true
    end,

    ["Pao"] = function(player)
        setPedAnimation(player, "FOOD", "EAT_Burger", 1200, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "comer")
        setTimer(function()
            local fomeAtual = getElementData(player, "hunger") or 0
            setElementData(player, "hunger", math.min(fomeAtual + 25, 100))
            outputChatBox("#FF9900[INV] #FFFFFFVocê comeu um pão.", player, 255, 255, 255, true)
        end, 1200, 1)
        return true
    end,

    ["Biscoito"] = function(player)
        setPedAnimation(player, "FOOD", "EAT_Burger", 1200, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "comer")
        setTimer(function()
            local fomeAtual = getElementData(player, "hunger") or 0
            setElementData(player, "hunger", math.min(fomeAtual + 15, 100))
            outputChatBox("#FF9900[INV] #FFFFFFVocê comeu biscoitos.", player, 255, 255, 255, true)
        end, 1200, 1)
        return true
    end,

    ["Agua"] = function(player)
        setPedAnimation(player, "VENDING", "VEND_Drink2_P", 1200, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "beber")
        setTimer(function()
            local sedeAtual = getElementData(player, "thirst") or 0
            setElementData(player, "thirst", math.min(sedeAtual + 40, 100))
            outputChatBox("#00CCFF[INV] #FFFFFFVocê bebeu Água.", player, 255, 255, 255, true)
        end, 1200, 1)
        return true
    end,

    ["Coca Cola"] = function(player)
        setPedAnimation(player, "VENDING", "VEND_Drink2_P", 1200, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "beber")
        setTimer(function()
            local sedeAtual = getElementData(player, "thirst") or 0
            setElementData(player, "thirst", math.min(sedeAtual + 25, 100))
            outputChatBox("#00CCFF[INV] #FFFFFFVocê bebeu uma Coca-Cola.", player, 255, 255, 255, true)
        end, 1200, 1)
        return true
    end,

    ["Energetico"] = function(player)
        setPedAnimation(player, "VENDING", "VEND_Drink2_P", 1200, false, false, false, false)
        triggerClientEvent(root, "inventario:tocarSom3D", player, player, "beber")
        setTimer(function()
            local stamina = getElementData(player, "stamina") or 0
            setElementData(player, "stamina", math.min(stamina + 50, 100))
            outputChatBox("#FFFF00[INV] #FFFFFFEnergético usado. Stamina recuperada!", player, 255, 255, 255, true)
        end, 1200, 1)
        return true
    end,

    ["Relogio"] = function(player)
        setElementData(player, "possui:relogio", true)
        outputChatBox("#FFFF00[INV] #FFFFFFVocê agora pode ver as horas.", player, 255, 255, 255, true)
        return false
    end,

    ["Mapa"] = function(player)
        setElementData(player, "possui:mapa", true)
        outputChatBox("#FFFF00[INV] #FFFFFFVocê agora pode abrir o mapa (F11).", player, 255, 255, 255, true)
        return false
    end,

    ["Kit de Limpeza"] = function(player)
        local arma = getPedWeapon(player)
        if arma ~= 0 then
            setPedAnimation(player, "PYTHON", "python_reload", 1500, false, false, false, false)
            setTimer(function()
                setElementData(player, "arma_limpeza", 100)
                outputChatBox("#00FF00[INV] #FFFFFFSua arma foi limpa e não irá travar.", player, 255, 255, 255, true)
            end, 1500, 1)
            return true
        else
            outputChatBox("#FF0000[INV] #FFFFFFSegure uma arma para limpar.", player, 255, 255, 255, true)
            return false
        end
    end
}

-- EVENTO PRINCIPAL: USAR ITEM
addEvent("inventario:usarItem", true)
addEventHandler("inventario:usarItem", root, function(nomeItem)
    if acoesItens[nomeItem] then
        local deveRemover = acoesItens[nomeItem](client)
        if deveRemover then
            triggerClientEvent(client, "inventario:removerItemClient", client, nomeItem)
        end
    else
        outputChatBox("#FF0000[ERRO] #FFFFFFItem sem função programada.", client, 255, 255, 255, true)
    end
end)

-- EVENTO PARA DESEQUIPAR ARMA
addEvent("inventario:desequiparArma", true)
addEventHandler("inventario:desequiparArma", root, function(nomeItem)
    if nomeItem == "AK-47" then
        if getPedWeapon(client) == 30 then
            takeWeapon(client, 30)
            triggerClientEvent(root, "inventario:tocarSom3D", client, client, "desequipar")
            outputChatBox("#FFFF00[INV] #FFFFFFVocê desequipou sua AK-47.", client, 255, 255, 255, true)
        else
            outputChatBox("#FF0000[INV] #FFFFFFVocê não está segurando esta arma.", client, 255, 255, 255, true)
        end
    end
end)

-- EVENTO PARA DESCARTAR ITEM (DROP)
addEvent("inventario:descartarItem", true)
addEventHandler("inventario:descartarItem", root, function(nomeItem, quantidade)
    local quantidade = tonumber(quantidade)
    if not quantidade or quantidade <= 0 then 
        outputChatBox("#FF0000[ERRO] #FFFFFFQuantidade inválida.", client, 255, 255, 255, true)
        return 
    end

    local x, y, z = getElementPosition(client)
    local objetoDrop = createObject(1222, x, y, z - 0.9)
    setElementInterior(objetoDrop, getElementInterior(client))
    setElementDimension(objetoDrop, getElementDimension(client))
    
    setTimer(destroyElement, 300000, 1, objetoDrop)

    triggerClientEvent(client, "inventario:removerQtdEspecifica", client, nomeItem, quantidade)
    outputChatBox("#FF9900[INV] #FFFFFFVocê descartou " .. quantidade .. "x " .. nomeItem .. ".", client, 255, 255, 255, true)
end)

-- BLOQUEIO DO MAPA (F11)
addEventHandler("onPlayerCommand", root, function(cmd)
    if cmd == "showmap" then
        if not getElementData(source, "possui:mapa") then
            outputChatBox("#FF0000[AVISO] #FFFFFFVocê precisa de um Mapa físico para abrir o GPS!", source, 255, 255, 255, true)
            cancelEvent()
        end
    end
end)

config_items.lua

-- config_items.lua

-- Definimos uma tabela global para que outros scripts acessem
ItemData = {}

-- Estrutura: ["Nome do Item"] = { propriedades }
ItemData.Lista = {
    -- === COMIDAS (IMEDIATAS) ===
    ["Pao"] = { peso = 0.2, fome = 25, sede = -5, decomposicao = 0.5, img = "assets/items/pao.png", cat = "COMIDA E BEBIDA", desc = "Um pão simples, mas mata a fome." },
    ["Biscoito"] = { peso = 0.1, fome = 15, sede = -10, decomposicao = 0.1, img = "assets/items/biscoito.png", cat = "COMIDA E BEBIDA", desc = "Crocante e seco." },

    -- === COMIDAS (COZINHAR) ===
    ["Carne Crua"] = { peso = 0.5, fome = 5, toxina = 40, precisaCozinhar = true, decomposicao = 2.0, img = "assets/items/carne_crua.png", cat = "COMIDA E BEBIDA", desc = "Precisa ser cozida antes de comer." },
    ["Miojo"] = { peso = 0.1, fome = 30, precisaCozinhar = true, precisaPanela = true, img = "assets/items/miojo.png", cat = "COMIDA E BEBIDA", desc = "Rápido de fazer, se tiver água quente." },
    ["Sardinha"] = { peso = 0.3, fome = 20, precisaAbridor = true, img = "assets/items/sardinha.png", cat = "COMIDA E BEBIDA", desc = "Fonte de proteína enlatada." },
    ["Feijao Enlatado"] = { peso = 0.4, fome = 35, precisaAbridor = true, img = "assets/items/feijao.png", cat = "COMIDA E BEBIDA", desc = "Feijão nutritivo, mas precisa abrir a lata." },

    -- === BEBIDAS ===
    ["Agua"] = { peso = 0.5, sede = 40, decomposicao = 0, img = "assets/items/agua.png", cat = "COMIDA E BEBIDA", desc = "Essencial para a vida." },
    ["Suco"] = { peso = 0.4, sede = 35, fome = 5, img = "assets/items/suco.png", cat = "COMIDA E BEBIDA", desc = "Suco natural refrescante." },
    ["Cantil"] = { peso = 0.6, sede = 50, reutilizavel = true, img = "assets/items/cantil.png", cat = "COMIDA E BEBIDA", desc = "Pode ser reabastecido em fontes de água." },
    ["Coca Cola"] = { peso = 0.4, sede = 30, energia = 10, decomposicao = 0.2, img = "assets/items/coca.png", cat = "COMIDA E BEBIDA", desc = "Dá um pico de energia." },
    ["Energetico"] = { peso = 0.3, sede = 20, stamina = 50, img = "assets/items/energetico.png", cat = "COMIDA E BEBIDA", desc = "Recupera sua stamina rapidamente." },

    -- === EQUIPAMENTOS (HABILITADORES) ===
    ["Relogio"] = { peso = 0.1, habilita = "relogio", img = "assets/items/relogio.png", cat = "EQUIPAMENTOS", desc = "Permite ver a hora atual." },
    ["Mapa"] = { peso = 0.1, habilita = "mapa", img = "assets/items/mapa.png", cat = "EQUIPAMENTOS", desc = "Necessário para abrir o GPS (F11)." },
    ["Bussola"] = { peso = 0.2, habilita = "bussola", img = "assets/items/bussola.png", cat = "EQUIPAMENTOS", desc = "Mostra a direção no radar." },
    ["Isqueiro"] = { peso = 0.05, ferramenta = "fogo", img = "assets/items/isqueiro.png", cat = "EQUIPAMENTOS", desc = "Usado para acender fogueiras." },
    ["Binoculos"] = { peso = 0.5, acao = "zoom", img = "assets/items/binoculos.png", cat = "EQUIPAMENTOS", desc = "Observar alvos à distância." },
    ["Lanterna"] = { peso = 0.4, ferramenta = "luz", precisaPilha = true, img = "assets/items/lanterna.png", cat = "EQUIPAMENTOS", desc = "Ilumina locais escuros." },
    ["Visao Noturna"] = { peso = 0.8, acao = "nightvision", precisaPilha = true, img = "assets/items/nvg.png", cat = "EQUIPAMENTOS", desc = "Ver no escuro total." },
    ["Panela"] = { peso = 1.0, ferramenta = "cozinhar", img = "assets/items/panela.png", cat = "EQUIPAMENTOS", desc = "Necessária para preparar alimentos." },
    ["Abridor"] = { peso = 0.1, ferramenta = "abrir", img = "assets/items/abridor.png", cat = "EQUIPAMENTOS", desc = "Usado para abrir latas de comida." },
    ["Radio"] = { peso = 0.4, acao = "comunicacao", precisaPilha = true, img = "assets/items/radio.png", cat = "EQUIPAMENTOS", desc = "Falar com seu clã em frequências privadas." },
    ["Pilha"] = { peso = 0.05, acumulavel = true, img = "assets/items/pilha.png", cat = "EQUIPAMENTOS", desc = "Energia para lanternas e rádios." },
    ["Gerador"] = { peso = 15.0, ferramenta = "energia_base", img = "assets/items/gerador.png", cat = "EQUIPAMENTOS", desc = "Fornece energia para a geladeira da base." },

    -- === ARMAS E MANUTENÇÃO ===
    ["AK-47"] = { peso = 4.5, armaID = 30, durabilidade = 100, precisaLimpeza = true, img = "assets/items/ak47.png", cat = "ARMAS", desc = "Rifle potente. Mantenha limpo!" },
    ["Kit de Limpeza"] = { peso = 0.8, reparaLimpeza = 50, img = "assets/items/kit_limpeza.png", cat = "EQUIPAMENTOS", desc = "Limpa resíduos de pólvora da arma." },

    -- === SAÚDE ===
    ["Bandedi"] = { peso = 0.05, cura = 10, img = "assets/items/bandedi.png", cat = "SAÚDE", desc = "Curativo simples para pequenos cortes." },
    ["Kit Medico"] = { peso = 1.0, cura = 100, tempoUso = 5000, img = "assets/items/medkit.png", cat = "SAÚDE", desc = "Cura completa e lenta." },
    ["Dipirona"] = { peso = 0.02, cura = 20, cura_doenca = 15, img = "assets/items/dipirona.png", cat = "SAÚDE", desc = "Ajuda a baixar a febre e dor leve." },
    ["Dorflex"] = { peso = 0.05, curaTemporaria = 40, efeitoRebote = 60000, img = "assets/items/dorflex.png", cat = "SAÚDE", desc = "Cura rápida, mas a dor volta depois." },
    ["Adrenalina"] = { peso = 0.2, acao = "reviver", img = "assets/items/adrenalina.png", cat = "SAÚDE", desc = "Usado para levantar aliados caídos." },
    ["Vacina Inovex"] = { peso = 0.1, cura_doenca = 100, img = "assets/items/vacina.png", cat = "SAÚDE", desc = "Cura avançada para infecções e vírus." },
    ["Cha de Ervas"] = { peso = 0.2, cura_doenca = 30, sede = 10, img = "assets/items/cha.png", cat = "SAÚDE", desc = "Remédio natural para mal-estar." },

    -- === MATERIAIS (CRAFTING) ===
    ["Madeira"] = { peso = 2.0, acumulavel = true, img = "assets/items/madeira.png", cat = "OUTROS" },
    ["Metal"] = { peso = 3.0, acumulavel = true, img = "assets/items/metal.png", cat = "OUTROS" },
    ["Vidro"] = { peso = 1.0, acumulavel = true, img = "assets/items/vidro.png", cat = "OUTROS" },
    ["Plastico"] = { peso = 0.5, acumulavel = true, img = "assets/items/plastico.png", cat = "OUTROS" },
    ["Fio"] = { peso = 0.2, acumulavel = true, img = "assets/items/fio.png", cat = "OUTROS" },
    ["Pedra"] = { peso = 2.5, acumulavel = true, img = "assets/items/pedra.png", cat = "OUTROS" },
    ["Tecido"] = { peso = 0.3, acumulavel = true, img = "assets/items/tecido.png", cat = "OUTROS" },
    ["Eletronicos"] = { peso = 0.8, acumulavel = true, img = "assets/items/eletronicos.png", cat = "OUTROS" },
    ["Cola"] = { peso = 0.1, acumulavel = true, img = "assets/items/cola.png", cat = "OUTROS" },
    ["Fita"] = { peso = 0.1, acumulavel = true, img = "assets/items/fita.png", cat = "OUTROS" },
    ["Prego"] = { peso = 0.01, acumulavel = true, img = "assets/items/prego.png", cat = "OUTROS" },
    ["Parafuso"] = { peso = 0.01, acumulavel = true, img = "assets/items/parafuso.png", cat = "OUTROS" },

    -- === FERRAMENTAS ===
    ["Martelo"] = { peso = 1.2, durabilidade = 100, img = "assets/items/martelo.png", cat = "OUTROS" },
    ["Alicate"] = { peso = 0.6, acao = "desarmar", img = "assets/items/alicate.png", cat = "OUTROS" },
    ["Chave De Fenda"] = { peso = 0.3, img = "assets/items/chave_fenda.png", cat = "OUTROS" },
    ["Macaco"] = { peso = 4.0, img = "assets/items/macaco.png", cat = "OUTROS" },
    ["Chave Inglesa"] = { peso = 1.5, img = "assets/items/chave_inglesa.png", cat = "OUTROS" },

    -- === VEÍCULOS ===
    ["Bateria"] = { peso = 5.0, veiculoPart = "battery", img = "assets/items/bateria.png", cat = "EQUIPAMENTOS" },
    ["Rodas"] = { peso = 4.0, veiculoPart = "wheel_kit", img = "assets/items/rodas.png", cat = "EQUIPAMENTOS" },
    ["Pneus"] = { peso = 2.0, veiculoPart = "tire", img = "assets/items/pneus.png", cat = "EQUIPAMENTOS" },
    ["Volante"] = { peso = 1.5, veiculoPart = "steering", img = "assets/items/volante.png", cat = "EQUIPAMENTOS" },
    ["Radiador"] = { peso = 3.0, veiculoPart = "radiator", img = "assets/items/radiador.png", cat = "EQUIPAMENTOS" },
    ["Vela"] = { peso = 0.1, veiculoPart = "spark_plug", img = "assets/items/vela.png", cat = "EQUIPAMENTOS" },
    ["Kit de reparo Para Veiculo"] = { peso = 2.0, reparaVeiculo = 40, img = "assets/items/kit_veiculo.png", cat = "EQUIPAMENTOS" },
    ["Galao De Gasolina"] = { peso = 2.5, combustivel = 20, img = "assets/items/gasolina.png", cat = "EQUIPAMENTOS" },
}

-- Função útil para pegar dados do item de forma segura
function getDefaults(nome)
    return ItemData.Lista[nome] or false
end
