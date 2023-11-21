createdMushrooms = {}

CreateThread(function()
	while true do
		local coords = GetEntityCoords(PlayerPedId())
	
        for k,v in pairs(Config.MushroomSpawns) do 
	    local distance = #(coords - v.location)
            if distance < v.radius then
                spawnMushroom(k)
                Wait(500)
            else
                Wait(1500)
            end
        end
        Wait(25)
	end
end)

function spawnMushroom(locationIndex)
	while Config.MushroomSpawns[locationIndex].createdMushroom < 15 do
        print('spawnMushroom', 105, locationIndex)
		Wait(1)
		local mushroomCords = generateMushroomCoords(locationIndex)

		SpawnObject('prop_stoneshroom1', mushroomCords, function(obj)
            table.insert(createdMushrooms, obj)
            Config.MushroomSpawns[locationIndex].createdMushroom = Config.MushroomSpawns[locationIndex].createdMushroom + 1
		end)
	end
end 

function generateMushroomCoords(locationIndex)
    local mushroomCord = Config.MushroomSpawns[locationIndex].location
    while true do
        Wait(1)
        math.randomseed(GetGameTimer())
        local modX = math.random(-35, 35)
        Wait(100)
        math.randomseed(GetGameTimer())
        local modY = math.random(-35, 35)
        local mushroomCordX = mushroomCord.x + modX
        local mushroomCordY = mushroomCord.y + modY
        local coordZ = getCoordZ(mushroomCordX, mushroomCordY)
        local coord = vector3(mushroomCordX, mushroomCordY, coordZ)
        print(coord, 105)
        if getMushroomCoord(coord, locationIndex) then
            return coord
        end
    end
end

function getCoordZ(x, y)
    local groundCheckHeights = { 1000.0, 500.0, 250.0, 100.0, 50.0, 25.0, 10.0, 5.0, 1.0, 0.5, 0.1 }
    for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
        if foundGround then
            return z
        end
    end
    return 53.85
end

function getMushroomCoord(mushCoord, locationIndex)
    if next(createdMushrooms) then
        local validate = true
        for k, v in pairs(createdMushrooms) do
            if GetDistanceBetweenCoords(mushCoord, GetEntityCoords(v), true) < 5 then
                validate = false
            end
        end
        for k, v in pairs(Config.MushroomSpawns) do
            if GetDistanceBetweenCoords(mushCoord, v.location, false) > 50 then
                validate = false
            end
        end
        return validate
    else
        return true
    end
end

function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

function pickMushroom()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local locationIndex = getLocationIndex()
    for k, v in pairs(createdMushrooms) do
        if GetDistanceBetweenCoords(playerCoords, GetEntityCoords(v), true) < 1.5 then
            Config.MushroomSpawns[locationIndex].createdMushroom = Config.MushroomSpawns[locationIndex].createdMushroom - 1
            startAnimation(v)
            DeleteObject(v)
            table.remove(createdMushrooms, k)
            Wait(Config.RespawnTime * 1000)
            break
        end
    end
end

function getLocationIndex()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    for k, v in pairs(Config.MushroomSpawns) do
        if GetDistanceBetweenCoords(playerCoords, v.location, true) < v.radius then
            return k
        end
    end
end

function startAnimation(v)
    makeEntityFaceEntity(PlayerPedId(), v)
    local createMushroomType = createMushroomType()
    TaskStartScenarioInPlace(PlayerPedId(), Config.PickAnimation, 0, true)
    Wait(Config.PickTime * 1000)
    ClearPedTasks(PlayerPedId())
    TriggerServerEvent('mgnMushroom:server:pickMushroom', createMushroomType)
end

function createMushroomType()
    local redChance = Config.SpawnChances.redMushroom
    local blueChance = Config.SpawnChances.blueMushroom
    local random = math.random(1, 100)
    print(redChance, blueChance, random)
    if random <= redChance then
        return 'redmushroom'
    elseif random <= blueChance then
        return 'bluemushroom'
    else
        return 'redmushroom'
    end 
end

function makeEntityFaceEntity( entity1, entity2 )
    local p1 = GetEntityCoords(entity1, true)
    local p2 = GetEntityCoords(entity2, true)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    local heading = GetHeadingFromVector_2d(dx, dy)
    SetEntityHeading( entity1, heading )
end

-- Target

exports['qb-target']:AddTargetModel(`prop_stoneshroom1`, {
    options = {
        {
            icon = "fas fa-mushroom",
            label = "Pick Mushroom",
            action = function()
                pickMushroom()
            end
        },
    },
    distance = 1.0
}) 
