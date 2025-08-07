# EMERGE Manager Changelog

All notable changes to the EMERGE manager (emerge-manager.lua) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.7] - 2025-08-07

### Fixed
- **CRITICAL**: Fixed race condition in `checkAllUpdates()` function
- `emodule update` now properly waits for async operations to complete
- Manager update checks no longer use stale cache data (force refresh)
- Added proper timeout protection (10s total, 8s per download)
- Fixed race where `pending_update` was evaluated before download completion

### Changed
- Replaced fixed 3-second timer with proper event-driven async coordination
- `checkSelfUpdate()` now delegates to new async version for consistency
- Cache refresh now forces fresh data during update checks (`force=true`)
- Improved error messages with timeout and network issue detection

### Added
- New `checkSelfUpdateAsync()` method with callback-based completion
- Completion state tracking to coordinate multiple async operations
- Individual download timeout protection with cleanup
- Better debug output showing progress of async operations

## [0.5.6] - 2025-08-07

### Fixed
- **CRITICAL**: Fixed module loading failure after successful download
- Enhanced error reporting - no more truncated error messages
- Added file existence verification before loading
- Improved error context with full file paths and specific error types
- Added debug output for module save location and file size

### Added
- Progress feedback during module loading process
- Module installation tracking (modules marked as installed)
- System event emission (`module.installed`) for EMERGE integration
- Better error categorization (parse errors vs execution errors)

### Improved
- Complete error messages with context and troubleshooting hints
- Better debugging information when debug mode is enabled
- File operation error handling with specific failure reasons

## [0.5.5] - 2025-08-07

### Changed
- Simplified and shortened `emodule help` output
- Condensed upgrade commands into single line explanation
- Removed lengthy examples section for cleaner help display
- More concise command reference

## [0.5.4] - 2025-08-07

### Fixed
- **CRITICAL**: Fixed module loading giving zero feedback
- Replaced `downloadFile` with `getHTTP` for module downloads (same as manifest downloads)
- Fixed missing `manifest_path` conversion from manifest `path` field
- Added proper error handling and success messages for module loading
- Added debug output to help diagnose loading issues

### Root Cause
- Private repo modules were failing silently because `downloadFile` doesn't handle auth headers properly
- Manifest modules were missing the `manifest_path` field needed for URL construction
- No error feedback when downloads failed

### Now Working
- `emodule load emerge-test-module` should now provide clear feedback
- Both success and error states are properly reported
- Private repository modules can be loaded with authentication

## [0.5.3] - 2025-08-07

### Fixed
- Fixed malformed color tags showing `</reset>` as literal text in display
- Fixed version display and footer formatting issues
- Corrected separator characters in command footer

## [0.5.2] - 2025-08-07

### Fixed
- `emodule update` now properly checks BOTH manager and modules for updates
- Fixed issue where manager updates weren't shown in `emodule update`

### Added
- New comprehensive upgrade system with `emodule upgrade <component>`
- `emodule upgrade all` - Upgrades everything that has updates
- `emodule upgrade manager` - Upgrades just the manager
- `emodule upgrade <module>` - Upgrades a specific module
- Better progress tracking and feedback during upgrades

### Changed
- `emodule update` now checks manager + all modules (no longer silent about manager)
- Improved help text to reflect new upgrade commands
- Better error messages and usage instructions

### Commands Summary
- `emodule update` → Check everything for updates
- `emodule upgrade <what>` → Actually upgrade something

## [0.5.1] - 2025-08-07

### Fixed
- Fixed DarkGrey color tag not rendering properly in module list
- Repository headers now display correctly with proper color formatting

### Improved
- More professional and polished module list display
- Added emoji icons for better visual hierarchy (🚀 🕒 📋 💡 ⚠️)
- Better visual separators between repositories
- Cleaner version display formatting
- Beta warning indicator in footer

## [0.5.0] - 2025-08-07

### IMPORTANT: Version Reset
- Reset version from 1.3.1 to 0.5.0 to accurately reflect pre-production status
- EMERGE is functional but still in active development
- Breaking changes may occur before 1.0.0 release
- This is beta software - expect bugs and ongoing improvements

### Status
- Core functionality: Working
- GitHub integration: Working (public and private repos)
- Module discovery: Working
- Branch loading: Working
- Production ready: **NO** - still in development

## [Previously 1.3.1] - 2025-08-07

### Changed
- Standardized all displays to use 100-character width for consistency
- Repository grouping restored for both Required and Optional modules
- Both module sections now use identical formatting with repository headers
- Updated all separator lines to match 100-character width

### Improved
- Visual consistency across all EMERGE displays
- Module organization by repository for better clarity
- Cleaner, more professional appearance with fixed width

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