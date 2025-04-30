print("Hello from script.lua!")

local TextChatService = game:GetService("TextChatService")
local HttpService = game:GetService("HttpService")

-- Webhook URL (replace with your actual GitHub or Discord webhook URL)
local WEBHOOK_URL = "https://discord.com/api/webhooks/1367189918929129482/BI2UU7_DsZFk5N7tat87ocJh4Rue_3OKITiGpIGV3d0I4KsBA1Ga11n3wJKK5OWQ1pRy" -- e.g., "https://discord.com/api/webhooks/..."

-- Function to split a string into words (since Lua doesn't have split)
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

-- Set the OnIncomingMessage callback
TextChatService.OnIncomingMessage = function(message)
    local rawText = stripRichText(message.Text)
    local sender = message.TextSource
    local username = sender and sender.Name or "Unknown"

    -- Check if the message contains "just hatched a"
    print(rawText:lower())
    if rawText:lower():find("just hatched a") then
        -- Split the message into words
        local words = splitString(rawText, " ")

        -- Extract pet and odds
        local petStart = rawText:lower():find("just hatched a") + #"just hatched a"
        local petEnd = rawText:find("%(") or #rawText
        local pet = rawText:sub(petStart, petEnd - 1):match("^%s*(.-)%s*$") or "Unknown"
        local odds = words[#words]:gsub("[%(%)]", ""):match("^%s*(.-)%s*$") or "Unknown"

        -- Determine embed color
        local color
        if pet:lower():find("mythic") then
            color = 0x800080 -- Purple
        elseif pet:lower():find("shiny") then
            color = 0xffff00 -- Yellow
        else
            color = 0x00ff00 -- Default green
        end

        -- Create the embed payload
        local embed = {
            title = "New Pet Found!",
            description = usernameяться

        -- Send to webhook
        local payload = {
            embeds = {embed}
        }
        local success, error = pcall(function()
            HttpService:PostAsync(
                WEBHOOK_URL,
                HttpService:JSONEncode(payload),
                Enum.HttpContentType.ApplicationJson
            )
        end)

        if not success then
            warn("Failed to send webhook: " .. tostring(error))
        end
    end
end
