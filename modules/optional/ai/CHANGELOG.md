# EMERGE AI Module Changelog

## [0.5.1] - 2025-08-07

### Added
- Complete alias-based interface - no lua commands required
- API key management aliases:
  - `ai apikey groq <key>` - Set Groq API key
  - `ai apikey openai <key>` - Set OpenAI API key  
  - `ai apikey clear <provider>` - Clear API keys
- Proper module unload with `ai unload` command
- Help data table for EMERGE help system integration
- Request rate limiting (30 requests per minute)
- Enhanced help command with dynamic status display
- Rate limit status in help output

### Fixed
- All commands now use aliases instead of requiring lua
- Complete cleanup on module unload
- Proper event-driven architecture compliance
- Security: Removed hardcoded API keys

### Changed
- Version bumped from 0.1.0 to 0.5.1
- Improved help system using module.help_data
- Better error messages referencing alias commands

## [0.1.0] - 2025-08-07

### Added
- Initial EMERGE-compliant conversion from standalone AI module
- Multi-provider support (Ollama, Groq, OpenAI)
- Event-driven architecture
- Conversation history management
- Buffer capture for context
- Roleplay functionality with emote generation
- Full integration with emerge.events, emerge.state, emerge.config
- Comprehensive test suite with 89.7% coverage