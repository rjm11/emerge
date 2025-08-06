# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

EMERGE (Emergent Modular Engagement & Response Generation Engine) is a modular system manager for the Mudlet MUD client, specifically designed for Achaea. It provides a framework for loading, managing, and updating Lua modules from GitHub repositories.

## Architecture

### Core Components

The system consists of a single main file `emerge-manager.lua` that implements:

1. **Module Registry System** - Maintains a list of available modules with metadata (name, description, GitHub location)
2. **GitHub Integration** - Downloads modules directly from GitHub repositories, supports private repos via tokens
3. **Configuration Management** - Persists settings and custom modules in JSON files
4. **Event System** - Modules can register/unregister themselves and interact through events
5. **Auto-update Mechanism** - Checks for updates and can self-upgrade

### Key Data Structures

- `EMERGE.modules` - Loaded module instances
- `EMERGE.default_registry` - Built-in module definitions
- `EMERGE.custom_modules` - User-added module definitions
- `EMERGE.config` - System configuration (auto-update, tokens, etc.)

### File Locations

All configuration and cache files are stored in Mudlet's home directory:
- `emerge-config.json` - Main configuration
- `emerge-custom-modules.json` - User-added modules
- `emerge-cache/` - Downloaded module files

## Commands

### Module Management
- `emodule list` - List all modules (loaded and available)
- `emodule load <id>` - Download and load a module from GitHub
- `emodule unload <id>` - Unload a loaded module
- `emodule enable <id>` - Enable a module for auto-loading
- `emodule disable <id>` - Disable a module

### GitHub Integration
- `emodule github <owner/repo>` - Add a module from a GitHub repository
- `emodule token <token>` - Set GitHub personal access token for private repos
- `emodule remove <id>` - Remove a custom module

### System Maintenance
- `emodule update` - Check all modules for updates
- `emodule upgrade` - Upgrade the EMERGE manager itself
- `emodule unload manager confirm` - Completely remove EMERGE from Mudlet

## Module Development

Modules are Lua scripts that follow this pattern:

1. Register with EMERGE using `EMERGE:register(module_id, module_table)`
2. Module table should include: `name`, `version`, optional `unload()` function
3. Modules can use Mudlet's full API for triggers, aliases, timers, etc.
4. Clean up resources in the `unload()` function when module is removed

## Working with Private Repositories

The system supports private GitHub repositories through personal access tokens:
1. Create a token at github.com/settings/tokens with 'repo' scope
2. Set token using `emodule token <your_token>`
3. Token is stored in the configuration file for persistent access

## Important Implementation Details

- The manager creates a persistent loader script in Mudlet to auto-load on startup
- Modules are loaded in order based on their `load_order` property
- Core module is marked as required and provides the foundational event system
- Version checking compares semantic version strings for updates
- Downloaded modules are cached locally to avoid repeated downloads