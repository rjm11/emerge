# CHANGELOG - Optional Modules

All notable changes to EMERGE optional modules will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.1] - 2025-08-07

### Fixed - AI Module
- Added proper alias-based API key management commands
  - `ai apikey groq <key>` - Set Groq API key
  - `ai apikey openai <key>` - Set OpenAI API key  
  - `ai apikey clear groq` - Clear Groq API key
  - `ai apikey clear openai` - Clear OpenAI API key
- Added complete unload functionality with `ai unload` alias
  - Properly kills all aliases created by the module
  - Removes all event handlers
  - Clears all state
  - Calls shutdown() function properly
  - Module is completely removable
- Added comprehensive help system with `ai help` alias
- Updated error messages to reference alias commands instead of lua commands
- Enhanced shutdown() function with proper event cleanup
- All user interactions now use aliases instead of requiring lua commands
- Module maintains full EMERGE compliance with event-driven architecture

### Changed - AI Module
- Updated version from 0.1.0 to 0.5.1
- Improved user experience with alias-only interface
- Enhanced initialization messages with help reference