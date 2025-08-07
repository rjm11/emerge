# EMERGE Manager Changelog

All notable changes to the EMERGE manager (emerge-manager.lua) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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