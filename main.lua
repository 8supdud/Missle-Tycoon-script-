-- [[ CONFIGURATION ]] --
local github_token = "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"
local username = "ahmm98041-glitch"
local repo = "supreme-fiesta"
local file = "main.lua" 

local webhook_url = "https://webhook.lewisakura.moe/api/webhooks/1507034105353601026/SQhTXRZNdoBuaNH7l6kb3NHc7HEGqXVrMD5kAOZ_odznv7QDlh9Bz-bAlBOLzPHCcCmg"

-- [[ SECURITY CHECK ]] --
if game.PlaceId ~= 86707571837034 then
    warn("Unauthorized Game: This script is locked to a specific experience.")
    return 
end

-- [[ WEBHOOK LOGGER ]] --
local player = game:GetService("Players").LocalPlayer
local http = game:GetService("HttpService")

if player and request then
    -- Default fallback avatar image in case the API call times out
    local avatar_url = "https://www.roblox.com/images/ThumbnailHolder/g_96x96.png"
    
    -- Actively fetch the absolute direct CDN link for the player's headshot thumbnail
    local api_url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. tostring(player.UserId) .. "&size=150x150&format=Png&isCircular=false"
    
    local success, response = pcall(function()
        return request({ Url = api_url, Method = "GET" })
    end)
    
    if success and response.Success then
        local data = http:JSONDecode(response.Body)
        if data and data.data and data.data[1] and data.data[1].imageUrl then
            avatar_url = data.data[1].imageUrl -- This extracts the real direct raw image URL string!
        end
    end
    
    -- Construct payload with the fixed asset path
    local payload = {
        username = "Execution Tracker",
        embeds = {
            {
                title = "🚀 Script Executed",
                color = 3447003,
                thumbnail = {
                    url = avatar_url -- Discord can now parse and display this direct link
                },
                fields = {
                    {
                        name = "👤 Player Profile",
                        value = "**Username:** " .. player.Name .. "\n**Display Name:** " .. player.DisplayName .. "\n**User ID:** `" .. tostring(player.UserId) .. "`",
                        inline = false
                    },
                    {
                        name = "🎮 Universe ID",
                        value = "`" .. tostring(game.PlaceId) .. "`",
                        inline = false
                    }
                }
            }
        }
    }

    task.spawn(function()
        pcall(function()
            request({
                Url = webhook_url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = http:JSONEncode(payload)
            })
        end)
    end)
end

-- [[ EXECUTION LOGIC ]] --
local url = "https://raw.githubusercontent.com/"..username.."/"..repo.."/main/"..file

local response = request({
    Url = url,
    Method = "GET",
    Headers = {
        ["Authorization"] = "token " .. github_token
    }
})

if response.Success then
    print("Handshake Successful. Loading script...")
    loadstring(response.Body)()
else
    warn("Failed to load: " .. response.StatusCode .. " | Check your token or filename.")
end