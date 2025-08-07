# EMERGE Manager Changelog

All notable changes to the EMERGE manager (emerge-manager.lua) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.3] - 2025-01-07

### Changed
- Reverted to cleaner, simpler quick installer in README
- Removed unnecessary post-install instructions from installer
- Simplified installer output for better user experience

## [1.1.2] - 2025-01-07

### Added
- Force upgrade command (`emodule upgrade force`) to bypass version checking
- Ability to re-download manager even when version appears current

### Changed
- Updated help text to include force upgrade option

## [1.1.1] - 2025-01-07

### Fixed
- Repository naming (changed from "emerge-public" to "emerge")
- Private repository discovery only attempts when token is set
- Improved error messages when manifest.json not found
- Better handling when no repositories are available
- Fixed pending downloads counter when repos are skipped

### Changed
- Enabled emerge-private repository by default (with token check)
- Improved debug output for repository discovery

## [1.1.0] - 2025-01-07

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

## [0.5.7] - 2025-01-06

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