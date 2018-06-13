--
-- @Project: FiveM Tools
-- @Author: Samuelds
-- @License: GNU General Public License v3.0
--

local markers = {}
local activeMarkers = {}
local currentMarker = nil

--
-- Add Marker in the markers table
--
function AddMarker(...)
    local args = {...}
    local count = #args
    if count == 1 then
        assert(type(args[1]) == "table", "Data is not table")

        for name, value in pairs(args[1]) do
            Citizen.Wait(1)
            markers[name] = marker.new(value)

            if value.enable == nil or value.enable == true then
                activeMarkers[name] = true
            end
        end
    elseif count == 2 then
        local name = args[1]
        local value = args[2]
        markers[name] = marker.new(value)

        if value.enable == nil or value.enable == true then
            activeMarkers[name] = true
        end
    end
end

--
-- Remove Marker in the markers table
--
function RemoveMarker(...)
    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then
        for _, name in ipairs(args[1]) do
            Citizen.Wait(1)
            markers[name] = nil
            activeMarkers[name] = nil
        end
    elseif count == 1 then
        local name = args[1]
        markers[name] = nil
        activeMarkers[name] = nil
    end
end

--
-- Add Marker to activeMarkers table
--
function EnableMarker(...)
    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then
        for _, name in pairs(args[1]) do
            Citizen.Wait(1)
            if markers[name] then
                activeMarkers[name] = true
            end
        end
    elseif count == 1 then
        local name = args[1]
        if markers[name] then
            activeMarkers[name] = true
        end
    end
end

--
-- Remove Marker to activeMarkers table
--
function DisableMarker(...)
    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table"  then
        for _, name in pairs(args[1]) do
            Citizen.Wait(1)
            activeMarkers[name] = nil
        end
    elseif count == 1 then
        local name = args[1]
        activeMarkers[name] = nil
    end
end

--
-- Add or Remove Marker to activeMarkers table
--
function SwitchMarker(...)
    local args = {...}
    local count = #args
    if count == 1 and type(args[1]) == "table" then
        for name, status in pairs(args[1]) do
            Citizen.Wait(1)
            if activeMarkers[name] then
                activeMarkers[name] = nil
            else
                activeMarkers[name] = true
            end
        end
    elseif count == 1 then
        local name = args[1]
        local status = args[2]
        if activeMarkers[name] then
            activeMarkers[name] = nil
        else
            activeMarkers[name] = true
        end
    end
end

--
-- Get Current Marker
--
function CurrentMarker()
    return currentMarker
end

--
-- Add check for global frame
--
AddRunInFrame(function()

    local playerPed = GetPlayerPed(-1)
    local playerLocalisation = GetEntityCoords(playerPed)
    for name, value in pairs(activeMarkers) do

        local target = markers[name]
        if target then
            if GetDistanceBetweenCoords(target.x, target.y, target.z, playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, true) <= target.showDistance then
                target:Show()
                currentMarker = name
            elseif currentMarker == name then
                currentMarker = nil
            end
        else
            Citizen.Trace("Marker " .. name .. " empty")
        end

    end

end)
