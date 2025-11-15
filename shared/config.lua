Config = {}

--Logs discord
Config.DiscordWebhook = ""


Config.ProgressTime = 5 -- Tempes braquage + fouilles (en sec)


Config.Rewards = {
    firearm = { -- Armes a feu
        { item = 'money', min = 200, max = 500 },
        { item = 'bread', min = 1,   max = 1 },
    },
    melee = { -- Armes blanches
        { item = 'money', min = 50, max = 150 },
        { item = 'bread', min = 1,  max = 5 },

    },
}

Config.alertJob = {
    alert = true,         -- Activer l'alert (ESX OBLIGATOIR)
    jobs = { "ambulance", "police" },
    timeToRemoveBlip = 20 -- temps avant suppression du blip (en sec)
}
