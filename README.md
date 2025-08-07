# EMERGE - Emergent Modular Engagement & Response Generation Engine

A next-generation combat system for Achaea built on event-driven architecture.

## 🚀 Quick Install

Copy and paste this **entire command** into Mudlet:

```lua
lua if EMERGE and EMERGE.loaded then cecho("\n<SlateGray>╔════════════════════════════════════════════╗<reset>\n") cecho("<SlateGray>║           <LightSteelBlue>EMERGE SYSTEM STATUS<SlateGray>             ║<reset>\n") cecho("<SlateGray>╚════════════════════════════════════════════╝<reset>\n\n") cecho("<green>✓ EMERGE is already installed<reset>\n") cecho("<DimGrey>Version: "..(EMERGE.version or "unknown").."<reset>\n\n") cecho("<LightSteelBlue>Commands:<reset>\n") cecho("  <SteelBlue>emodule help<reset>     - View all commands\n") cecho("  <SteelBlue>emodule list<reset>     - See available modules\n") cecho("  <SteelBlue>emodule refresh<reset>  - Discover modules\n") else cecho("\n<SlateGray>╔════════════════════════════════════════════╗<reset>\n") cecho("<SlateGray>║           <LightSteelBlue>EMERGE SYSTEM INSTALLER<SlateGray>          ║<reset>\n") cecho("<SlateGray>╚════════════════════════════════════════════╝<reset>\n\n") local f=getMudletHomeDir().."/emerge-manager.lua" cecho("<DimGrey>• Downloading EMERGE manager...<reset>\n") downloadFile(f,"https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") local h,e h=registerAnonymousEventHandler("sysDownloadDone",function(ev,p) if p==f then killAnonymousEventHandler(h) if e then killAnonymousEventHandler(e) end cecho("<DimGrey>• Download complete<reset>\n") cecho("<DimGrey>• Installing EMERGE system...<reset>\n") local x,r=pcall(dofile,p) if x then cecho("<green>✓ Installation successful!<reset>\n\n") cecho("<LightSteelBlue>EMERGE is now installed.<reset>\n\n") cecho("<yellow>Next Steps:<reset>\n") cecho("1. Set your GitHub token (for private modules):\n") cecho("   <SteelBlue>emodule token ghp_YOUR_TOKEN<reset>\n\n") cecho("2. Discover available modules:\n") cecho("   <SteelBlue>emodule refresh<reset>\n\n") cecho("3. List modules:\n") cecho("   <SteelBlue>emodule list<reset>\n\n") cecho("4. Load core modules:\n") cecho("   <SteelBlue>emodule load emerge-core<reset>\n\n") cecho("<DimGrey>Type 'emodule help' for all commands<reset>\n") else cecho("<red>✗ Installation failed: "..(r or "unknown error").."<reset>\n") end end end) e=registerAnonymousEventHandler("sysDownloadError",function(ev,p) if p==f then if h then killAnonymousEventHandler(h) end killAnonymousEventHandler(e) cecho("<red>✗ Download failed. Please check your internet connection.<reset>\n") end end) end
```

## 📦 What is EMERGE?

EMERGE is a modular combat system for Achaea that uses event-driven architecture where complex behaviors emerge from simple module interactions.

### Key Features:
- **Modular Design** - Load only what you need
- **Event-Driven** - No direct module calls (Golden Rule)
- **GitHub Integration** - Automatic module discovery and updates
- **Multi-Repository** - Public and private module support
- **Version Management** - Never auto-updates without permission

## 🎮 Basic Commands

After installation, use these commands:

- `emodule help` - View all available commands
- `emodule list` - Show loaded and available modules
- `emodule refresh` - Discover modules from repositories
- `emodule search <term>` - Search for specific modules
- `emodule load <module>` - Load a specific module
- `emodule info <module>` - Get detailed module information

## 🔑 GitHub Token Setup

To access private modules, you'll need a GitHub token:

1. Go to [GitHub Settings > Tokens](https://github.com/settings/tokens)
2. Generate new token (classic)
3. Select `repo` scope
4. Copy the token
5. In Mudlet: `emodule token ghp_YOUR_TOKEN_HERE`

## 📚 Available Modules

### Core Modules (Private Repository)
- `emerge-core` - Enhanced event system
- `emerge-gmcp` - GMCP data handler
- `emerge-help` - Help system

### Optional Modules
- `emerge-test-module` - Example module
- More coming soon!

## 🛠️ Development

Want to contribute? Check out our [Development Repository](https://github.com/rjm11/emerge-dev)

## 📜 License

MIT License - See LICENSE file for details

## 💬 Support

- Issues: [GitHub Issues](https://github.com/rjm11/emerge/issues)
- Development: [emerge-dev](https://github.com/rjm11/emerge-dev)

---

*From simplicity, emerges victory.*