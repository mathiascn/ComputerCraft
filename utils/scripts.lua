--- Script Management Table
-- This table contains mappings for all the scripts used in the ComputerCraft setup.
-- Each entry in the table represents a script, including its name, Pastebin hash, directory, and type.

local scripts = {
    -- UTILS: Utility scripts used by both master computers and turtles.
    
    --- Update Script
    -- This script handles updates for other scripts on the master computer.
    -- @field name The name of the script.
    -- @field hash The unique Pastebin hash used to download the script.
    -- @field directory The directory where the script will be stored.
    -- @field type The type of system the script is meant for (e.g., "master" or "turtle").
    update = {
        name = "update",
        hash = "zi3jCmxp",
        directory = "",
        type = "master"
    },

    --- Startup Script for Master
    -- Ensures proper startup routines for the master computer.
    startup = {
        name = "startup",
        hash = "ZVedN58L",
        directory = "/disk",
        type = "master"
    },

    --- Script Manager
    -- Updates this script.
    scripts = {
        name = "scripts",
        hash = "E9GKK1GW",
        directory = "/disk",
        type = "master"
    },

    --- Utility Functions
    -- A collection of general-purpose utility functions used across scripts.
    utils = {
        name = "utils",
        hash = "xheJgpxv",
        directory = "/disk",
        type = "turtle"
    },

    --- Constants
    -- Stores global constants used across various scripts.
    constants = {
        name = "constants",
        hash = "PFC28C5a",
        directory = "/disk",
        type = "turtle"
    },

    --- JSON Parser
    -- Provides JSON parsing and encoding functionalities for Lua scripts.
    json = {
        name = "json",
        hash = "vmb1T7yy",
        directory = "/disk",
        type = "turtle"
    },

    --- API Client
    -- Manages HTTP requests and API interactions.
    api_client = {
        name = "api_client",
        hash = "v2UuEtUW",
        directory = "/disk",
        type = "turtle"
    },

    --- Quick Tool Lua
    -- Provides an interactive shell for executing Lua code.
    qtlua = {
        name = "qtlua",
        hash = "hxyy2yQ6",
        directory = "/disk",
        type = "turtle"
    },

    --- Timer Utility
    -- Manages timer functions for time-based tasks.
    timer = {
        name = "timer",
        hash = "2f1tK8UE",
        directory = "/disk",
        type = "turtle"
    },

    --- Tuning Script
    -- Used for quick one-time tuning of Ender Chests.
    tune = {
        name = "tune",
        hash = "d9uitEtd",
        directory = "/disk",
        type = "turtle"
    },

    -- TURTLE SCRIPTS: Scripts specifically designed to run on turtles.
    
    --- Cube Mining Script
    -- Automates mining in a cube-shaped area.
    cubeMine = {
        name = "cubeMine",
        hash = "za0Cz2ct",
        directory = "/disk",
        type = "turtle"
    },

    --- Lumberjack Script
    -- Automates tree chopping and wood collection.
    lumberjack = {
        name = "lumberjack",
        hash = "vfkp3A17",
        directory = "/disk",
        type = "turtle"
    },

    --- Farmer Script
    -- Automates planting, harvesting, and managing crops.
    farmer = {
        name = "farmer",
        hash = "GpkHSR0p",
        directory = "/disk",
        type = "turtle"
    },

    --- Quarry Script
    -- Automates the process of digging quarries for resource collection.
    quarry = {
        name = "quarry",
        hash = "Y9TvHnJd",
        directory = "/disk",
        type = "turtle"
    },

    --- Turtle Bot
    -- A general-purpose bot for managing turtle operations.
    turtle_bot = {
        name = "turtle_bot",
        hash = "7tmqR0Uf",
        directory = "/disk",
        type = "turtle"
    },

    --- Turtle Display Script
    -- Displays the status and tasks of turtles on monitors.
    display_turtles = {
        name = "display_turtles",
        hash = "FN1jv2xa",
        directory = "/disk",
        type = "turtle"
    },

    --- Turtle Startup Script
    -- Ensures turtles load necessary scripts and configurations on startup.
    -- Should be renamed to startup once its saved to a turtle
    turtle_startup = {
        name = "turtle_startup",
        hash = "hfCrGgt5",
        directory = "/disk",
        type = "turtle"
    },

    --- Excavator Script
    -- Automates excavation tasks for digging large areas.
    excavator = {
        name = "excavator",
        hash = "w4frwPJ5",
        directory = "/disk",
        type = "turtle"
    },

    --- Mason Script
    -- Automates construction tasks by laying down blocks in predefined patterns.
    mason = {
        name = "mason",
        hash = "DwwKBRaf",
        directory = "/disk",
        type = "turtle"
    },

    --- Landfill Script
    -- Automates the process of filling in large areas with blocks.
    landfill = {
        name = "landfill",
        hash = "n2VBMTXb",
        directory = "/disk",
        type = "turtle"
    }
}

return scripts