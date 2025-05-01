print("Hello from script.lua!")

local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

-- Function to split a string into words
local function splitString(input, delimiter)
    local words = {}
    for word in string.gmatch(input, "[^" .. delimiter .. "]+") do
        table.insert(words, word)
    end
    return words
end

-- Function to strip rich text tags
local function stripRichText(input)
    if not input then
        return ""
    end
    return input:gsub("<[^>]+>", "")
end

local function sendData(data)
    local params = {
        username = HttpService:UrlEncode(data.username),
        pet = HttpService:UrlEncode(data.pet),
        odds = HttpService:UrlEncode(data.odds),
        raw = HttpService:UrlEncode(data.raw)
    }

    local url = string.format(
        "%s?username=%s&pet=%s&odds=%s&raw=%s",
        "https://syncstride.best/pets",
        params.username,
        params.pet,
        params.odds,
        params.raw
    )

    print(url)
    game:HttpGet(url)
end

local function addMessage(message)
    local rawText = stripRichText(message.Text)

    local petStart = rawText:lower():find("just hatched a") + #"just hatched a"
    local petEnd = rawText:find("%(") or #rawText
    local pet = rawText:sub(petStart, petEnd - 1):match("^%s*(.-)%s*$") or "Unknown"

    local words = splitString(rawText, " ")
    local username = words[2]
    local odds = words[#words]:gsub("[%(%)]", ""):match("^%s*(.-)%s*$") or "Unknown"

    local uuid = HttpService:GenerateGUID(false)

    local messageData = {
        username = username,
        pet = pet,
        odds = odds,
        raw = rawText,
        uuid = uuid
    }

    sendData(messageData)
end

-- Set the OnIncomingMessage callback
TextChatService.OnIncomingMessage = function(message)
    local rawText = stripRichText(message.Text)
    local sender = message.TextSource
    local username = sender and sender.Name or "System"

    -- Check if the message contains "just hatched a"
    if rawText:lower():find("just hatched a") and username == "System" then
        -- Split the message into words
        addMessage(message)
    end
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterLoadPromise:Wait()
local humanoid = character:WaitForChild("Humanoid")

coroutine.wrap(function()
    while true do
        humanoid.Jump = true;
        wait(30)
    end
end)()

print("Script loaded v1")
