local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Selector%20hub.lua"))()

if Games then
    local found = false
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            loadstring(game:HttpGet(Execute))()
            found = true
            break
        end
    end

    if not found then
        print("erro: entre e execute em um jogo válido")
    end
else
    print("erro: carregar...")
end
