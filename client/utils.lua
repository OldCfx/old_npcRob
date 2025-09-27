function Draw3DProgressBar(entity, progress, width, height, zOffset)
    if not DoesEntityExist(entity) then return end


    width = width or 0.12
    height = height or 0.015
    zOffset = zOffset or 1.2

    local entCoords = GetEntityCoords(entity)


    local wx, wy, wz = table.unpack(GetOffsetFromEntityInWorldCoords(entity, 0.0, 0.0, zOffset))


    local onScreen, screenX, screenY = World3dToScreen2d(wx, wy, wz)

    if onScreen then
        DrawRect(screenX, screenY, width, height, 40, 40, 40, 200)

        local fillCenterX = screenX - (width / 2) + (width * progress / 2)
        local fillWidth = math.max(0.0001, width * math.max(0.0, math.min(1.0, progress)))

        DrawRect(fillCenterX, screenY, fillWidth, height * 0.95, 0, 200, 0, 230)
    end
end

function IsPlayerThreatening(playerPed, targetPed)
    local weapon = exports.ox_inventory:getCurrentWeapon()
    if not weapon then
        return false
    end

    if not weapon.melee then
        local aiming, aimedEntity = GetEntityPlayerIsFreeAimingAt(PlayerId())
        return aiming and aimedEntity == targetPed
    else
        local dist = #(GetEntityCoords(playerPed) - GetEntityCoords(targetPed))
        if dist < 2.5 then
            return IsPedInMeleeCombat(playerPed)
        end
    end

    return false
end
