local options = require("options")

data:extend{
    {
        type = "double-setting",
        name = "duration-until-lockdown-scalar",
        setting_type = "runtime-global",
        order = "a-a",
        minimum_value = 0,
        default_value = 15,
    },
    {
        type = "string-setting",
        name = "duration-until-lockdown-unit",
        setting_type = "runtime-global",
        order = "a-b",
        default_value = options.durationUnit[2],
        allowed_values = options.durationUnit,
    },
    {
        type = "bool-setting",
        name = "lockdown-minable",
        setting_type = "runtime-global",
        order = "a-c",
        default_value = true,
    },
    {
        type = "bool-setting",
        name = "lockdown-rotatable",
        setting_type = "runtime-global",
        order = "a-d",
        default_value = true,
    },
}