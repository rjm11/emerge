# EMERGE Manager Changelog

All notable changes to the EMERGE manager (emerge-manager.lua) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] - 2025-08-07

### Added
- Branch support for module loading: `emodule load <branch> <module>`
- Ability to load modules from experimental or development branches
- Branch indicator shown when loading from non-default branch

### Changed
- Updated help text to include branch loading syntax
- Added examples for branch-based module loading

### Use Cases
- Test experimental fixes: `emodule load testbranch emerge-test-module`
- Load development versions: `emodule load dev emerge-core`
- Try bug fixes before merging: `emodule load bugfix-123 module-name`

## [1.2.2] - 2025-08-07

### Fixed
- Made Optional Modules formatting consistent with Required Modules
- Removed repository grouping and extra indentation from Optional Modules
- Both sections now use the same clean format with repository shown inline

## [1.2.1] - 2025-08-07

### Fixed
- Restored full descriptions in module list
- Let Mudlet handle word wrapping naturally (no manual line breaks)
- Descriptions now display on single line, Mudlet wraps as needed

## [1.2.0] - 2025-08-07

### Changed
- Removed long descriptions from module list display
- Module list now shows only module name and version
- Let Mudlet handle line wrapping naturally
- Cleaner, more compact module listing

## [1.1.9] - 2025-08-07

### Added
- New command: `emodule load required` - Loads all required modules automatically
- Split module list into Required and Optional sections for clarity
- Better visual hierarchy in module listing with section headers

### Changed  
- Disabled automatic update checking on startup (was running after 40 seconds)
- Made token verification refresh silent (no more verbose output)
- Completely redesigned `emodule list` output for better readability
- Required modules now marked with green diamonds (♦)
- Optional modules marked with yellow diamonds (♢)
- Added helpful prompts for loading required modules

### Fixed
- Removed unexpected "Checking all modules for updates" messages
- Update checking now only happens when explicitly requested

### Improved
- Module list layout with clear sections and better spacing
- Visual separation between module categories
- Grouped optional modules by repository source

## [1.1.8] - 2025-08-07

### Changed
- Now recommends fine-grained personal access tokens for better security
- Updated all token instructions to prefer github_pat_ tokens
- Fine-grained tokens allow limiting access to specific repositories only
- More secure: only grants read access to Contents, not full repo control

### Security
- Fine-grained tokens are now the recommended approach
- Instructions guide users to select only necessary repositories
- Minimal permissions (Contents: Read) for enhanced security

## [1.1.7] - 2025-08-07

### Fixed
- **CRITICAL**: Replaced downloadFile with getHTTP for GitHub API calls
- Private repository access now works correctly with authentication
- Both classic (ghp_*) and fine-grained (github_pat_*) tokens now function

### Changed
- Complete rewrite of downloadManifest to use getHTTP instead of downloadFile
- Improved error handling with proper event-driven callbacks
- Better debug output for troubleshooting connection issues

### Technical
- Uses sysGetHttpDone and sysGetHttpError events (Mudlet 4.10+)
- Properly handles Authorization headers for private repos
- Verified working with Mudlet 4.19.1

## [1.1.6] - 2025-08-07

### Changed
- Unified all token instructions to use classic tokens (ghp_*)
- Updated introduction screen to match token command help
- Fixed example token format in help text
- Consistent messaging that classic tokens work better with Mudlet

## [1.1.5] - 2025-08-07

### Fixed
- GitHub token authorization header format for classic vs fine-grained tokens
- Classic tokens (ghp_*) now use "token" format
- Fine-grained tokens (github_pat_*) now use "Bearer" format
- Auto-detection of token type for proper authorization

## [1.1.4] - 2025-08-07

### Added  
- Token command now automatically verifies repository access
- Token command triggers module discovery after saving
- Verification feedback shows if private repos are accessible

### Changed
- GitHub token URL updated to correct personal-access-tokens page
- Discovery only shows warnings for repos we expect to access
- Improved token verification with actual connectivity test

### Fixed
- Private repository access verification after token setup

## [1.1.3] - 2025-08-07

### Changed
- Reverted to cleaner, simpler quick installer in README
- Removed unnecessary post-install instructions from installer
- Simplified installer output for better user experience

## [1.1.2] - 2025-08-07

### Added
- Force upgrade command (`emodule upgrade force`) to bypass version checking
- Ability to re-download manager even when version appears current

### Changed
- Updated help text to include force upgrade option

## [1.1.1] - 2025-08-07

### Fixed
- Repository naming (changed from "emerge-public" to "emerge")
- Private repository discovery only attempts when token is set
- Improved error messages when manifest.json not found
- Better handling when no repositories are available
- Fixed pending downloads counter when repos are skipped

### Changed
- Enabled emerge-private repository by default (with token check)
- Improved debug output for repository discovery

## [1.1.0] - 2025-08-07

### Added
- Full GitHub repository discovery system
- Manifest.json support for module metadata
- Multi-repository configuration (public/private/dev)
- Module search functionality (`emodule search <term>`)
- Module info command (`emodule info <module>`)
- Repository listing (`emodule repos`)
- Cache management system (15-minute cache)
- Debug mode (`emodule debug`)
- Timeout protection for downloads
- Error handlers for network failures

### Changed
- Moved manager from manager/ subfolder to root for direct access
- Updated Authorization header to Bearer format for Mudlet compatibility
- Improved discovery to save partial results on timeout
- Enhanced module listing with version comparisons

### Fixed
- Download timeout issues preventing module discovery
- Version mismatch between manager and manifest
- Quick installer path reference

## [0.5.7] - 2025-08-06

### Added
- Initial module management system
- GitHub integration for updates
- Module loading/unloading
- Configuration persistence
- Auto-update checking

### Changed
- Refactored from standalone script to modular system

### Notes
- First public release of EMERGE manager