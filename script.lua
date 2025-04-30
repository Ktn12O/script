print("Hello from script.lua!")

local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

local foldername = "Data"
local filename = foldername .. "//messages.json"
local data = '{"messages": []}'

if not isfile(filename) then
    makefolder(foldername)
    writefile(filename, data)
    print("Created file " .. filename .. "!")
end

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

local function addMessage(message)
    local rawText = stripRichText(message.Text)

    local petStart = rawText:lower():find("just hatched a") + #"just hatched a"
    local petEnd = rawText:find("%(") or #rawText
    local pet = rawText:sub(petStart, petEnd - 1):match("^%s*(.-)%s*$") or "Unknown"

    local words = splitString(rawText, " ")
    local username = words[0]
    local odds = words[#words]:gsub("[%(%)]", ""):match("^%s*(.-)%s*$") or "Unknown"

    local uuid = HttpService:GenerateGUID(false)

    local messageData = {
        username = username,
        pet = pet,
        odds = odds,
        raw = rawText,
        uuid = uuid
    }

    local fileContent
    if isfile(filename) then
        fileContent = readfile(filename)
    else
        fileContent = HttpService:JSONEncode({messages = {} })
    end

    local success, decoded = pcall(function()
        return HttpService:JSONDecode(fileContent)
    end)

    if not success then
        warn("Failed to decode JSON: " .. tostring(decoded))
        return
    end
    
    table.insert(decoded.messages, messageData)

    local success, encoded = pcall(function()
        return HttpService:JSONEncode(decoded)
    end)

    if not success then
        warn("Failed to encode JSON: " .. tostring(encode))
        return
    end

    writefile(filename, encoded)
end

-- Set the OnIncomingMessage callback
TextChatService.OnIncomingMessage = function(message)
    local rawText = stripRichText(message.Text)
    local sender = message.TextSource
    local username = sender and sender.Name or "Unknown"

    -- Check if the message contains "just hatched a"
    if rawText:lower():find("just hatched a") then
        -- Split the message into words
        addMessage(message)
    end
end
