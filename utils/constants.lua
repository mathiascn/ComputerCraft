-- Constants for Directional Movement
-- Used for turtle directional movement
DIRECTIONS = {
    "North",
    "East",
    "South",
    "West",
}


-- Status Constants
-- Used for tracking current turtle script state
STATUS = {
    ERROR = "Error",
    IDLE = "Idle",
    FINISHED = "Finished",
    RUNNING = "Running",
    STARTING = "Starting"
}


-- Constants for Color Channels
-- These constants represent the frequencies used for Ender Chest color channels.
-- Each entry corresponds to a specific resource or function, using a combination of the 16 Minecraft colors.
-- For more information, visit: https://tweaked.cc/module/colors.html
COLOR_CHANNELS = {
    fuel = {2, 1, 1},
    farmingDepot = {2, 1, 2},
    logs = {2, 1, 4},
    seeds = {2, 1, 8},
    sapling = {2, 1, 16},
    manaGlass = {2, 1, 32},
    dirt = {2, 1, 64},
    stone = {2, 2, 1},
    miningDepot = {2, 2, 2},
}


-- Block Constants
-- These constants represent various blocks used in the scripts, identified by their Minecraft or modded names.
-- Each block is associated with its in-game identifier (name).
BLOCKS = {
    barrel = {name="mcp.mobius.betterbarrel"},
    carrot = {name="minecraft:carrot"},
    enderChest = {name="EnderStorage:enderChest"},
    leaves = {name="minecraft:leaves"},
    livingwood = {name="Botania:livingwood"},
    livingrock = {name="Botania:livingrock"},
    log = {name="minecraft:log"},
    potato = {name="minecraft:potatoes"},
    wheat = {name="minecraft:wheat"}
}


-- Item Constants
-- These constants represent various items used in the scripts, identified by their Minecraft or modded names.
-- Each item is associated with its in-game identifier (name) and damage value (damage).
ITEMS = {
    apple = {name="minecraft:apple", damage=0},
    carrot = {name="minecraft:carrot", damage=0},
    charcoal = {name="minecraft:coal", damage=1},
    coal = {name="minecraft:coal", damage=0},
    enderChest = {name="EnderStorage:enderChest", damage=0},
    log = {name="minecraft:log", damage=0},
    potato = {name="minecraft:potato", damage=0},
    sapling = {name="minecraft:sapling", damage=0},
    seeds = {name="minecraft:wheat_seeds", damage=0},
    stone = {name="minecraft:stone", damage=0},
}


-- Crop Constants
-- These constants represent various crops used in farming automation scripts.
-- Each crop has attributes like name, maturity level (mature), seed type, growth speed(seconds), and associated color channel.
CROPS = {
    wheat = {
        name = BLOCKS.wheat.name,
        mature = 7,                    -- The stage at which the crop is fully grown
        seed = ITEMS.seeds.name,       -- The seed used to plant this crop
        speed = 20 * 60,               -- Growth time in ticks (1 second = 20 ticks
        channel = COLOR_CHANNELS.seeds -- Color channel used for storage
    },
    carrot = {
        name = BLOCKS.carrot.name,
        mature = 7,
        seed = ITEMS.carrot.name,
        speed = 15 * 60
    },
    potato = {
        name = BLOCKS.potato.name,
        mature = 7,
        seed = ITEMS.potato.name,
        speed = 15 * 60
    },
    livingwood = {
        name = BLOCKS.livingwood.name,
        mature = 0,
        seed = ITEMS.log.name,
        speed = 65,
        channel = COLOR_CHANNELS.logs
    },
    livingrock = {
        name = BLOCKS.livingrock.name,
        mature = 0,
        seed = ITEMS.stone.name,
        speed = 65,
        channel = COLOR_CHANNELS.stone
    }
}