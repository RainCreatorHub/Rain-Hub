-- Npcs.lua
local Npcs = {}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Lista de fallback positions (pode ser usada no Main.lua)
Npcs.FallbackPositions = {
    SmallFish1 = CFrame.new(-255, 13, 931),
    BigFish = CFrame.new(-289, 21, -163),
    SmallFish2 = CFrame.new(367, -234, -233),
    StoneKid = CFrame.new(-59, 37, 239),
    StoneTeen = CFrame.new(-59, 37, 239),
    Frog = CFrame.new(-207, 70, -298),
    OscarFishBeta = CFrame.new(394, -275, 648),
    OscarFish = {
        CFrame.new(985, 59, 907),
        CFrame.new(1083, -228, 770),
        CFrame.new(1003, -229, 970)
    },
    DarkHolder = CFrame.new(1841, 404, 1485),
    WinterLoser = CFrame.new(2566, 411, 2677),
    Ender = CFrame.new(4207, 632, 2822),
    Minus = CFrame.new(5319, 671, 2417),
    KnightLoser = CFrame.new(4675, 1025, 3886)
}

-- Função que retorna NPC correto + altura para Tween baseado no nível
function Npcs.GetNpc()
    local level = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Level", 10).Value
    local npcName, studsY = nil, 8
    if level <= 4 then npcName = "SmallFish1"; studsY=5
    elseif level <= 21 then npcName = "BigFish"; studsY=5
    elseif level <= 29 then npcName = "SmallFish2"; studsY=6
    elseif level <= 33 then npcName = "StoneKid"; studsY=2
    elseif level <= 36 then npcName = "StoneTeen"; studsY=2
    elseif level <= 64 then npcName = "Frog"; studsY=2
    elseif level <= 74 then npcName = "OscarFishBeta"; studsY=3
    elseif level <= 178 then npcName = "OscarFish"; studsY=3
    elseif level <= 199 then npcName = "DarkHolder"; studsY=5
    elseif level <= 379 then npcName = "WinterLoser"; studsY=3
    elseif level <= 449 then npcName = "Ender"; studsY=6
    elseif level <= 514 then npcName = "Minus"; studsY=4
    elseif level >= 515 then npcName = "KnightLoser"; studsY=6 end
    return npcName, studsY
end

return Npcs
