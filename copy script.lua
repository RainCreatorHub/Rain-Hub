local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Selector%20hub.lua"))()

for PlaceID, Execute in pairs(Games) do
    if PlaceID == game.PlaceId then
        loadstring(game:HttpGet(Execute))()
    end
end
