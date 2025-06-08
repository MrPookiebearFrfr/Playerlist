RegisterNetEvent("blsrp:getPlayerList", function()
    local src = source
    local players = {}
    local policeCount = 0
    local emsCount = 0

    -- Try to get ESX object (adjust if using QBCore or other)
    local ESX = nil
    if GetResourceState('es_extended') == 'started' then
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end

    for _, playerId in ipairs(GetPlayers()) do
        local name = GetPlayerName(playerId)
        local discord = "N/A"
        local job = "unknown"

        -- Get Discord ID
        for _, id in ipairs(GetPlayerIdentifiers(playerId)) do
            if string.sub(id, 1, 8) == "discord:" then
                discord = string.sub(id, 9)
                break
            end
        end

        -- Get job (ESX example)
        if ESX then
            local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
            if xPlayer and xPlayer.job and xPlayer.job.name then
                job = xPlayer.job.name
                if job == "police" then
                    policeCount = policeCount + 1
                elseif job == "ambulance" or job == "ems" then
                    emsCount = emsCount + 1
                end
            end
        end

        table.insert(players, {
            name = name,
            id = tonumber(playerId),
            discord = discord,
            job = job
        })
    end

    -- Get on-duty police count from 911call resource
    policeCount = 0
    if exports["911call"] and exports["911call"].getOnDutyLawCount then
        policeCount = exports["911call"]:getOnDutyLawCount()
    end

    -- Get on-duty EMS count from NewEMSMENU resource
    emsCount = 0
    if exports["NewEMSMENU"] and exports["NewEMSMENU"].getOnDutyEMSCount then
        emsCount = exports["NewEMSMENU"]:getOnDutyEMSCount()
    end

    -- Get on-duty DOT count from BLSRP_M resource
    local dotCount = 0
    if exports["BLSRP_M"] and exports["BLSRP_M"].getOnDutyDotCount then
        dotCount = exports["BLSRP_M"]:getOnDutyDotCount()
    end

    TriggerClientEvent("blsrp:sendPlayerList", src, players, policeCount, emsCount, dotCount)
end)
