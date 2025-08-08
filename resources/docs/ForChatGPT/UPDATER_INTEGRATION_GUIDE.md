# Updater Module Integration Guide

This document outlines the plan for integrating the `updater.lua` module into the EMERGE system. The integration is designed to be seamless, handle initial installation automatically, and expose the necessary functions for manual updates.

The integration process is divided into three key steps:

### 1. Module Loading and Registration

**Goal:** Ensure the `updater` module is loaded at startup and correctly registered within the `achaea` namespace.

**Plan:**

-   **Modify `init.lua`**: The `load_order` table within `init.lua` will be updated to include the updater module.
-   **Load Order**: The `modules/updater` entry will be added to the `load_order` table. It should be loaded early in the sequence, right after the core modules, to ensure it's available for the initial installation check.
-   **Registration**: The module loader in `init.lua` will automatically attach the returned module table to the main `achaea` table. This will make the updater's functions available globally via `achaea.updater`.

**Conceptual Change in `init.lua`:**

```lua
-- In init.lua
local load_order = {
    -- Core modules...
    "core/events",
    "core/state",
    -- ...

    -- Load updater early
    "modules/updater",

    -- Other feature modules
    "modules/gmcp",
    "modules/balance",
    -- ...
}
```

### 2. Initial Installation Logic

**Goal:** Automate the download of system files for new users to simplify the first-time setup.

**Plan:**

-   **Modify `emerge.init()`**: A new block of code will be added to the `emerge.init()` function in `init.lua`.
-   **File Check**: This logic will execute early in the startup process. It will check for the existence of a critical core file, such as `achaea/modules/gmcp.lua`. The absence of this file is a reliable indicator of a fresh, incomplete installation.
-   **Trigger Update**: If the file does not exist, the system will automatically call `achaea.updater.update()`. This function will be responsible for downloading all necessary system files from the repository.
-   **User Notification**: A message will be displayed to the user, informing them that the initial installation is in progress and that a restart will be required upon completion.

**Conceptual Logic in `emerge.init()`:**

```lua
-- In init.lua, inside emerge.init()

-- After loading the updater module
if achaea.updater and not file_exists(achaea.module_path .. "modules/gmcp.lua") then
    cecho("<yellow>EMERGE core files not found. Starting automatic download...<yellow>")
    achaea.updater.update()
    cecho("<green>Download complete. Please restart Mudlet to finish the installation.<green>")
    -- Halt further execution to prevent errors
    return
end
```

### 3. Exposing Updater Functions

**Goal:** Make the `check()` and `update()` functions accessible to the user and other modules for manual version checks and updates.

**Plan:**

-   **Modify `modules/updater.lua`**: The `updater.lua` file will be structured to return a table containing the public functions.
-   **Public Interface**: The module will return a table that includes the `check` and `update` functions.

**Conceptual Structure of `modules/updater.lua`:**

```lua
-- In modules/updater.lua
local updater = {}

function updater.check()
    -- Logic to check the remote repository for a new version.
    print("Checking for updates...")
end

function updater.update()
    -- Logic to download all system files from the repository.
    print("Performing update...")
end

-- Return the public functions
return updater
```

By following these three steps, the `updater` module will be cleanly and effectively integrated into the EMERGE system, enhancing usability for both new and existing users.

