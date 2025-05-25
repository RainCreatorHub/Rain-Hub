local OrionLibV2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/OrionLibV2/refs/heads/main/OrionLibV2.lua"))()

local window = OrionLibV2:MakeWindow({
    Title = "Rain hub | Five nights: hunted",
    SubTitle = "by zaque_blox"
}(

local InfoTab = window:MakeTab({
    Name = "Info"
})

local Info = InfoTab:AddSection({
    Name = "Info"
})

local Incompleto = InfoTab:AddLabel({
    Name = "Esta incompleto",
    Content = "sera feito em breve!"
})
