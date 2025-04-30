local TextChatService = game:GetService("TextChatService")

-- Function to strip rich text tags and return raw text
local function stripRichText(input)
    if not input then
        return ""
    end
    local rawText = input
    rawText = rawText:gsub("<[^>]+>", "") -- Matches and removes any tag like <b>, </b>, <font ...>, etc.
    return rawText
end

-- Set the OnIncomingMessage callback
TextChatService.OnIncomingMessage = function(message)
    local sender = message.TextSource -- The user who sent the message
    local rawText = stripRichText(message.Text) -- Strip rich text tags
    local senderName = sender and sender.Name or "System" -- System messages may not have a sender

    print(senderName .. " said: " .. rawText)
end
