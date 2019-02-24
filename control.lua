local deque = require("deque.deque")
local options = require("options")

local duration_until_lockdown = nil
local lockdown_minable = true
local lockdown_rotatable = true

local function add_duration_to_existing_lockdown_ticks(duration)
    for tick_ent in global.entity_lock_queue:iter_left() do
        tick_ent[1] = tick_ent[1] + duration
    end
end

local function update_mod_settings()
    local new_duration = options.durationUnitMultiplyers[settings.global["duration-until-lockdown-unit"].value] * settings.global["duration-until-lockdown-scalar"].value
    lockdown_minable = settings.global["lockdown-minable"].value
    lockdown_rotatable = settings.global["lockdown-rotatable"].value

    if duration_until_lockdown ~= nil then
        local difference = new_duration - duration_until_lockdown
        if difference ~= 0 then
            add_duration_to_existing_lockdown_ticks(difference)
        end
    end

    duration_until_lockdown = new_duration
end

local function init_settings()
    global.entity_lock_queue = global.entity_lock_queue or deque.new()

    -- Metatable information is lost on save/load in Factorio
    setmetatable(global.entity_lock_queue, {__index = deque.methods})

    update_mod_settings()
end

local function game_loop_process_entity_locks(event)
    local tick, ent = nil, nil
    while not global.entity_lock_queue:is_empty() and global.entity_lock_queue:peek_left()[1] < event.tick do
        tick, ent = unpack(global.entity_lock_queue:pop_left())
        if ent.valid then
            ent.minable = not lockdown_minable
            ent.rotatable = not lockdown_rotatable
        end
    end
end

local function game_loop_entity_built(event)
    local entity = event.created_entity
    local is_tile_ghost = entity.name == "tile-ghost"
    local is_entity_ghost = entity.name == "entity-ghost"
    local is_ghost = is_entity_ghost or is_tile_ghost

    if is_ghost == false then
        global.entity_lock_queue:push_right({event.tick + duration_until_lockdown, entity})
    end
end

-- For fresh games & loading existing games
script.on_init(init_settings)
script.on_load(init_settings)

-- If a configuration/setting change occurred
script.on_configuration_changed(update_mod_settings)
script.on_event({defines.events.on_runtime_mod_setting_changed}, update_mod_settings)

-- Normal game loop
script.on_nth_tick(300, game_loop_process_entity_locks)
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, game_loop_entity_built)
