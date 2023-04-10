local isActive = false
local CurrentEntity = 0

-- get string label from model hash
function GetModelLabel(_ent)
    local entType = GetEntityType(_ent)
    local entHash = GetEntityModel(_ent)
    local entLabel = tostring(entHash)
    if not Models[entType] then return entLabel end
    for _,mLabel in pairs(Models[entType]) do if entHash == GetHashKey(mLabel) then entLabel = mLabel; break end end
    return entLabel.." ( "..tostring(entHash).." )"
end

-- prepare string with coords and heading
function GetModelCoordHeading(_ent)
    local coords = GetEntityCoords(_ent)
    return "x = "..round(coords.x, Config.DecR)..", y = "..round(coords.y, Config.DecR)..", z = "..round(coords.z, Config.DecR)..", h = "..round(GetEntityHeading(_ent), Config.DecR)
end

-- rounding decimals
function round(x, n)
    local count = tonumber(n) and tonumber(n) or 2
    return tonumber(string.format("%." .. count .. "f", tonumber(x)))
end

-- do some shape testing to get ray object
function GetInView()
    local player = PlayerPedId()
    local x1, y1, z1 = table.unpack(GetGameplayCamCoord())
    local pitch, roll, yaw = table.unpack(GetGameplayCamRot(2))
	local rx = -math.sin(math.rad(yaw)) * math.abs(math.cos(math.rad(pitch)))
	local ry =  math.cos(math.rad(yaw)) * math.abs(math.cos(math.rad(pitch)))
	local rz =  math.sin(math.rad(pitch))

	local x2 = x1 + rx * Config.Range
	local y2 = y1 + ry * Config.Range
	local z2 = z1 + rz * Config.Range
	local retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(StartShapeTestRay(x1, y1, z1, x2, y2, z2, -1, player, 1)) --check world
    -- no entity found
	if entityHit <= 0 or GetEntityType(entityHit) == 0 then return nil end
    return entityHit
end

-- update the object recognition each time its called by loop. Update NUI with entity information if a change is detected
function HandleUi()
    local entity = GetInView()
    if entity ~= CurrentEntity then 
        CurrentEntity = entity
        if CurrentEntity == nil then
            SendNUIMessage({type = "ui", display = true})
        else
            SendNUIMessage({type = "ui", display = true, entity = entity,
                label = GetModelLabel(CurrentEntity),
                coords = GetModelCoordHeading(CurrentEntity)
            })
        end
    end
end

-- main thread
Citizen.CreateThread(function()
    while true do
        if isActive then HandleUi() end
        Citizen.Wait(isActive and 50 or 1500)
    end
end)

-- hide active ui on resource stop
AddEventHandler('onResourceStop', function(resourceName) -- clear all on restart
	if GetCurrentResourceName() ~= resourceName then return end
    if isActive then SendNUIMessage({type = "ui", display = false}) end
end)

-- activate or deactivate ui
RegisterCommand('entityInfo', function(source, args, rawCommand)
    isActive = not isActive
    print("show target coords:",tostring(isActive))
    if not isActive then SendNUIMessage({type = "ui", display = false}) else SendNUIMessage({type = "ui", display = true}) end
end)

-- copy values from selected entity to clipboard
RegisterCommand('cpyEntityInfo', function(source, args, rawCommand)
    if CurrentEntity == nil or CurrentEntity == 0 then print("no entity selected!") return end
    SendNUIMessage({type = "cpy", value = "{"..GetModelCoordHeading(CurrentEntity).."},"})
    print("copied entity values to clipboard!")
end)