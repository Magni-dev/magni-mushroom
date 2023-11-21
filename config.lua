Config = {}

Config.PickAnimation = 'CODE_HUMAN_MEDIC_TEND_TO_DEAD'
Config.PickTime = 5-- Time it takes to pick a mushroom

-- Mushroom spawn settings
Config.MushroomTypes = {
    ['redMushroom'] = {
        label = 'Red Mushroom',
        effect = 'health', -- Define the effect or use of this
    },
    ['blueMushroom'] = {
        label = 'Blue Mushroom',
        effect = 'stamina'
    },
}

Config.SpawnChances = {
    redMushroom = 50,
    blueMushroom = 50
}

Config.MushroomSpawns = {
    { 
        location = vector3(632.29, 1546.22, 263.67),
        radius   = 50.0,
        createdMushroom = 0
    }
}

Config.RespawnTime = 15

-- Cooldown settings
Config.PickCooldown = 5