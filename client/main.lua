local robbing = false
local targetPed = nil
local canSearch = false

CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local aiming, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())

        if aiming and DoesEntityExist(entity) and IsEntityAPed(entity) and not IsPedAPlayer(entity) then
            local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(entity))

            if not robbing and dist < 3.0 then
                lib.showTextUI('[E] Braquer le PNJ', {
                    position = "left-center",
                    icon = 'hand-middle-finger',
                    style = {
                        borderRadius = 8,
                        backgroundColor = '#000000',
                        color = 'white'
                    }
                })

                if IsControlJustPressed(0, 38) then
                    StartRobNPC(entity, playerPed)
                end
            else
                lib.hideTextUI()
            end
        else
            lib.hideTextUI()
        end


        if canSearch and targetPed and DoesEntityExist(targetPed) then
            local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
            if dist < 2.5 then
                lib.showTextUI('[E] Fouiller le PNJ', {
                    position = "left-center",
                    icon = 'box-open',
                    style = {
                        borderRadius = 8,
                        backgroundColor = '#222222',
                        color = 'white'
                    }
                })
                if IsControlJustPressed(0, 38) then
                    SearchNPC(targetPed)
                end
            else
                lib.hideTextUI()
            end
        end
    end
end)


function StartRobNPC(entity, playerPed)
    if not DoesEntityExist(entity) then return end

    if Entity(entity).state.robbed then
        lib.notify({
            title = 'Braquage',
            description = 'Ce PNJ a déjà été braqué !',
            type = 'error'
        })
        return
    end

    robbing = true
    targetPed = entity


    if NetworkGetEntityIsNetworked(entity) then
        NetworkRequestControlOfEntity(entity)
        local t0 = GetGameTimer()
        while not NetworkHasControlOfEntity(entity) and (GetGameTimer() - t0) < 2000 do
            Wait(0)
        end
    end


    SetEntityAsMissionEntity(entity, true, true)
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedCanRagdoll(entity, false)
    SetEntityInvincible(entity, false)

    ClearPedTasksImmediately(entity)
    TaskStandStill(entity, 10000)


    RequestAnimDict("missminuteman_1ig_2")
    while not HasAnimDictLoaded("missminuteman_1ig_2") do Wait(0) end
    TaskPlayAnim(entity, "missminuteman_1ig_2", "handsup_base", 8.0, -8.0, -1, 49, 0, false, false, false)


    local progress = 0.0
    local aborted = false
    local done = false


    local step = 1.0 / (Config.ProgressTime * 60.0)


    while not done do
        Wait(0)

        if IsPlayerThreatening(playerPed, entity) then
            progress = progress + step
            if progress >= 1.0 then
                progress = 1.0
                done = true
            end
        else
            progress = progress - step
            if progress <= 0.0 then
                aborted = true
                break
            end
        end

        Draw3DProgressBar(entity, progress, 0.05, 0.009, 0.9)
    end


    if aborted then
        FreezeEntityPosition(entity, false)
        ClearPedTasks(entity)
        SetBlockingOfNonTemporaryEvents(entity, false)
        TaskSmartFleePed(entity, playerPed, 100.0, -1, false, false)
        robbing = false
        targetPed = nil
        lib.notify({ title = 'Braquage', description = 'Le PNJ a pris la fuite !', type = 'error' })
        return
    end


    ClearPedTasksImmediately(entity)
    RequestAnimDict("random@arrests@busted")
    while not HasAnimDictLoaded("random@arrests@busted") do Wait(0) end

    local coords = GetEntityCoords(entity)
    local heading = GetEntityHeading(entity)

    TaskPlayAnimAdvanced(entity, "random@arrests@busted", "idle_a", coords.x, coords.y, coords.z,
        0.0, 0.0, heading, 2.0, -2.0, -1, 33, 0, false, true)

    FreezeEntityPosition(entity, true)

    lib.notify({ title = 'Braquage', description = 'Le PNJ est à genoux... fouille-le.', type = 'inform' })
    canSearch = true
end

function SearchNPC(entity)
    canSearch = false
    local playerPed = PlayerPedId()
    lib.hideTextUI()


    RequestAnimDict("mini@repair")
    while not HasAnimDictLoaded("mini@repair") do Wait(0) end
    TaskPlayAnim(playerPed, "mini@repair", "fixing_a_player", 2.0, -2.0, 3000, 49, 0, false, false, false)

    lib.progressCircle({
        duration = Config.ProgressTime * 1000,
        position = 'bottom',
        label = 'Fouille en cours...',
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true },
    })

    ClearPedTasks(playerPed)
    local weapon = exports.ox_inventory:getCurrentWeapon()
    local category = weapon.melee and 'firearm' or 'melee'
    TriggerServerEvent('old_npcRob:reward', category, GetEntityCoords(entity), weapon.label,
        NetworkGetNetworkIdFromEntity(entity))
end

RegisterNetEvent('old_npcRob:stashClosed', function(inventoryId)
    if targetPed and DoesEntityExist(targetPed) then
        FreezeEntityPosition(targetPed, false)
        SetEntityCollision(targetPed, true, true)
        ClearPedTasks(targetPed)
        SetBlockingOfNonTemporaryEvents(targetPed, false)
        TaskSmartFleePed(targetPed, PlayerPedId(), 100.0, -1, false, false)
    end

    robbing = false
    targetPed = nil
    canSearch = false
end)
