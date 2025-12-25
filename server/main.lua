local Robberies = {}

--Logs discord
local webHook = ""

local function sendDiscordLog(title, message, color)
    if webHook == "" then return end
    local embed = {
        {
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 16753920,
            ["footer"] = { ["text"] = os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    PerformHttpRequest(webHook, function() end, 'POST',
        json.encode({ username = "NPC Robbery Logs", embeds = embed }),
        { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("old_npcRob:alertJob", function(coords)
    if Config.alertJob.alert then
        ESX = exports['es_extended']:getSharedObject()
        local groupedPlayers = ESX.GetExtendedPlayers("job", Config.alertJob.jobs)
        for group, players in pairs(groupedPlayers) do
            for i, xPlayer in ipairs(players) do
                TriggerClientEvent("ox_lib:notify", xPlayer.source, {
                    title = "Central",
                    description = "Un individu a été aperçu en train de braquer un citoyen",
                    type = "info",
                    icon = "fa-solid fa-shield-halved",
                    iconColor = "#1E90FF",
                    position = "top-center",
                    style = {
                        backgroundColor = "#0b1e33",
                        color = "white",
                        border = "1px solid #1E90FF",
                        borderRadius = "6px",
                    }
                })
                TriggerClientEvent("old_npcRob:createBlip", xPlayer.source, coords)
            end
        end
    end
end)


RegisterNetEvent('old_npcRob:reward', function(category, coords, weapon, netId)
    local src = source
    local rewards = Config.Rewards[category]

    if not rewards then return end


    local ped = netId and NetworkGetEntityFromNetworkId(netId)
    if ped and DoesEntityExist(ped) then
        if Entity(ped).state.robbed then return end
        Entity(ped).state.robbed = true
    end

    local items = {}
    for _, reward in ipairs(rewards) do
        local amount = math.random(reward.min, reward.max)
        if amount > 0 then
            table.insert(items, { reward.item, amount })
        end
    end

    local stashId = exports.ox_inventory:CreateTemporaryStash({
        label = 'Braquage',
        slots = #items > 0 and #items or 1,
        maxWeight = -1,
        items = items
    })

    Robberies[stashId] = {
        player = src,
        weapon = weapon,
        coords = coords,
        loot = items,
        ped = ped
    }

    TriggerClientEvent('ox_inventory:openInventory', src, 'stash', stashId)
end)


AddEventHandler('ox_inventory:closedInventory', function(playerId, inventoryId)
    if not Robberies[inventoryId] then return end

    local robbery = Robberies[inventoryId]
    Robberies[inventoryId] = nil

    local xPlayer = GetPlayerName(playerId) or "Unknown"

    local lootStr = ""
    for _, item in ipairs(robbery.loot) do
        lootStr = lootStr .. string.format("> %s x%s\n", item[1], item[2])
    end

    local coords = robbery.coords
    local location = string.format("%.2f, %.2f, %.2f", coords.x, coords.y, coords.z)

    local logMsg = string.format([[
        Joueur: **%s** [ID: %s]

        Arme: `%s`

        Position: %s

        Loot généré:
            %s
    ]], xPlayer, playerId, robbery.weapon or "Unknown", location,
        lootStr)

    sendDiscordLog("Braquage PNJ", logMsg, 15158332)

    TriggerClientEvent('old_npcRob:stashClosed', playerId, inventoryId)
end)
