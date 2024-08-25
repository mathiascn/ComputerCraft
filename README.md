# ComputerCraft Scripts

## Overview

This repository contains a collection of Lua scripts designed for use with the ComputerCraft mod in Minecraft. These scripts automate various tasks within the game, such as farming, mining, building, and resource management, enhancing gameplay and efficiency. Additionally, the repository includes several utility scripts that provide essential functionalities like timer management, API interactions, and configuration handling.

## Requirments
- Master computer
- Disk drive
- Floppy disk
- Turtle

## Features

### Main Scripts

- **Farmer.lua**: Automates the planting and harvesting of crops.
- **Lumberjack.lua**: Automates tree chopping and wood collection.
- **Landfill.lua**: Automates filling in large areas.
- **Excavator.lua**: Automates the excavation of large areas.
- **Display_Turtles.lua**: Manages and displays the status of multiple turtles on monitors.
- **Tune.lua**: Used for quick one time tuning of EnderChests.
- **Turtle_Bot.lua**: Provides a general-purpose bot for managing different turtle operations.
- **Turtle_Startup.lua**: Ensures turtles load scripts from master computer when placed next to it.
- **Mason.lua**: Automates construction tasks, laying down blocks according to predefined patterns.
- **Quarry.lua**: Automates the process of digging quarries, efficiently managing resources and space.

### Utility Scripts

- **api_client.lua**: Handles API interactions, allowing scripts to communicate with external services or manage HTTP requests.
- **constants.lua**: Stores global constants used across various scripts, centralizing key configuration variables.
- **json.lua**: Provides JSON parsing and encoding functionalities, enabling scripts to handle JSON data structures efficiently.
- **pastebinFix.lua**: Adapts the built-in pastebin script to work with the updated pastebin api.
- **qtlua.lua**: Interactive shell for Lua.
- **scripts.lua**: This file is an essential part of this repository, designed to map and manage the various Lua scripts included in this project. It allows for easy referencing and loading of scripts from Pastebin within the ComputerCraft environment.
- **startup.lua**: Handles startup routines for turtles, ensuring all necessary configurations and scripts are loaded upon boot.
- **timer.lua**: Provides timer management functions, useful for tasks that require time-based execution.
- **update.lua**: Used on a master computer to update scripts.
- **utils.lua**: A collection of general-purpose utility functions used across various scripts, simplifying common coding tasks.


### Steps to Install via Pastebin:

1. **Fix pastebin module**
   - The built-in pastebin module is outdated and needs a fix to work with the current pastebin api. 
   - Open shell on master computer
   - Copy and run this code: `local r = http.get("https://pastebin.com/raw/XzH1gK2e"); local f = fs.open(shell.resolve( "pastebin" ), "w"); f.write(r.readAll()); f.close(); r.close();`

2. **Upload Scripts to Pastebin**:
   - If you haven’t already, upload each script to Pastebin and note the unique hash provided for each script.

3. **Download Scripts in ComputerCraft**:
   - Open the terminal in your turtle or computer in Minecraft.
   - Use the `pastebin get` command followed by the unique code for the script you want to download.
   
   Example:
   ```lua
   pastebin get <hash> <name>
   ```

4. **Run the Script**:
   - Once the script is downloaded, you can run it directly from the terminal:
   ```lua
   farmer <args>
   ```


## Contributing

Contributions are welcome! If you have improvements or new features to add, feel free to fork this repository, make your changes, and submit a pull request.