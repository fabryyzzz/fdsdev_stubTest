Config = {}


Config.Framework = "esx" -- esx, qb
Config.Target = "ox" -- ox, qb
Config.jobs = {
    ["polizia"] = 3, -- minimum grade
    -- ["ambulance"] = 2,
}

Config.ForensicZones = {
    {
        database = vec3(483.781, -987.517, 30.69), -- you can add multiple zones
    }
}
Config.BlacklistedWeapons = {
    GetHashKey("weapon_snowball"),
}

Config.SecondsToClear = 30000 -- Seconds to clear in water
Config.DaysToClear = 5 -- Days in which gun powder can be found
Config.NeedToMoveInWater = true -- If the player needs to move into the water