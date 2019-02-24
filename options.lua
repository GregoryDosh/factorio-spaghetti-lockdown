local options = {}

options.durationUnit = {
    "Seconds",
    "Minutes",
    "Hours",
    "Days (Realtime)",
    "Days (In-Game)",
}

options.durationUnitMultiplyers = {
    ["Seconds"] = 60,
    ["Minutes"] = 3600,
    ["Hours"] = 216000,
    ["Days (Realtime)"] = 5184000,
    ["Days (In-Game)"] = 25000,
}

return options