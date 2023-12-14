local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local placeId = game.PlaceId
local serversApi = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"

function getLowestPopulatedServer()
    local servers = game:HttpGet(serversApi)
    local serverData = HttpService:JSONDecode(servers)

    if serverData and serverData.data then
        for _, server in pairs(serverData.data) do
            if server.playing < 3 then
                return server.id
            end
        end
    end

    return nil
end

function getNewestServer()
    local servers = game:HttpGet(serversApi)
    local serverData = HttpService:JSONDecode(servers)

    if serverData and serverData.data then
        local newestServer = serverData.data[#serverData.data]
        return newestServer.id
    end

    return nil
end

function teleportToServer(serverId)
    if serverId then
        TeleportService:TeleportToPlaceInstance(placeId, serverId, Players.LocalPlayer)
    else
        print("No suitable servers found.")
    end
end

-- Intenta encontrar un servidor con menos de 3 personas 10 veces
for i = 1, 10 do
    local targetServerId = getLowestPopulatedServer()
    
    if targetServerId then
        teleportToServer(targetServerId)
        break
    else
        wait(2)  -- Espera 2 segundos antes de intentar de nuevo
    end
end

-- Si no se encontró un servidor con menos de 3 personas, conectarse al más reciente
if not targetServerId then
    local newestServerId = getNewestServer()
    teleportToServer(newestServerId)
end
