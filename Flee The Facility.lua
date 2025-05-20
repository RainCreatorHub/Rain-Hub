local OrionLibV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local window = OrionLibV2:MakeWindow({
    Title = "Rain hub | Flee The Facility",
    SubTitle = "by zaque_blox"
})

local InfoTab = window:MakeTab({
    Name = "Info"
})

local InfoSection = InfoTab:AddSection({
    Name = "Info"
})

local playerName = game.Players.LocalPlayer.Name

local Label = Tab:AddLabel({
    Name = "Bem vindo(a) " .. playerName .. "!",
    Content = " "
})

local espTab = window:MakeTab({
    Name = "esp"
})

local section = espTab:AddSection({
    Name = "esp"
})

local espComputers = false
local espComputers = {}

function espComputersPlay()
   espComputers = true
end

function espComputersStop()
   espComputers = false
end

local ComputersEsp = espTab:AddToggle({
    Name = "Computers",
    Description = " ",
    Default = false,
    Callback = function(value)
      if value == true then
        espComputersPlay()
      end
      
      if value == false then
        espComputersStop()
      end
    end
})
