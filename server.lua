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