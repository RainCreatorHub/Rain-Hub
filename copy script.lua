local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Selector%20hub.lua"))()

if Games then
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
        end
    end

if Games then
  print("carregando...")
end

if not Games then
  print("erro ao carregar ou entre no jogo certo")
end
