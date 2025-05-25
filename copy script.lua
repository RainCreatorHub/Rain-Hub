local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Selector%20hub.lua"))()

if Games then
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
        end
        if not PlaceID == game.PlaceId then
            print("entre em 1 jogo que esteja na lista!")
        end
    end

if Games then
  print("carregando...")
end

if not Games then
  print("erro ao carregar...")
end
