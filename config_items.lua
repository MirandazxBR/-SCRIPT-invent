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