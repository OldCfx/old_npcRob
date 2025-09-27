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
