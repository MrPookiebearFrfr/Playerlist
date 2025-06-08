local isShowing = false

RegisterCommand("togglePlayerList", function()
    isShowing = not isShowing

    if isShowing then
        TriggerServerEvent("blsrp:getPlayerList")
        SendNUIMessage({ type = "show" })
        SetNuiFocus(false, false)
    else
        SendNUIMessage({ type = "hide" })
    end
end, false)

RegisterKeyMapping("togglePlayerList", "Toggle Player List UI", "keyboard", "F10")

RegisterNetEvent("blsrp:sendPlayerList", function(players, policeCount, emsCount, dotCount)
    SendNUIMessage({
        type = "updatePlayerList",
        players = players,
        policeCount = policeCount or 0,
        emsCount = emsCount or 0,
        dotCount = dotCount or 0
    })
end)
