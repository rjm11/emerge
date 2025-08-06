# EMERGE

Module Manager for the EMERGE Achaea System

## Quick Install

**Standard Installation** - Copy and paste this command into Mudlet:

```lua
lua if EMERGE and EMERGE.loaded then cecho("\n<SlateGray>╔════════════════════════════════════════════╗<reset>\n") cecho("<SlateGray>║           <LightSteelBlue>EMERGE SYSTEM INSTALLER<SlateGray>          ║<reset>\n") cecho("<SlateGray>╚════════════════════════════════════════════╝<reset>\n\n") cecho("<yellow>✓ EMERGE is already installed and running<reset>\n") cecho("<DimGrey>Version: "..(EMERGE.version or "unknown").."<reset>\n\n") cecho("<LightSteelBlue>Type 'emodule help' for commands<reset>\n") else cecho("\n<SlateGray>╔════════════════════════════════════════════╗<reset>\n") cecho("<SlateGray>║           <LightSteelBlue>EMERGE SYSTEM INSTALLER<SlateGray>          ║<reset>\n") cecho("<SlateGray>╚════════════════════════════════════════════╝<reset>\n\n") local f=getMudletHomeDir().."/emerge-manager.lua" cecho("<DimGrey>• Downloading latest version from GitHub...<reset>\n") downloadFile(f,"https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") local h,e h=registerAnonymousEventHandler("sysDownloadDone",function(ev,p) if p==f then killAnonymousEventHandler(h) if e then killAnonymousEventHandler(e) end cecho("<DimGrey>• Download complete<reset>\n") cecho("<DimGrey>• Installing EMERGE system...<reset>\n") local x,r=pcall(dofile,p) if x then cecho("<green>✓ Installation successful<reset>\n\n") cecho("<LightSteelBlue>EMERGE is now initializing...<reset>\n") else cecho("<red>✗ Installation failed: "..(r or "unknown error").."<reset>\n") end end end) e=registerAnonymousEventHandler("sysDownloadError",function(ev,p) if p==f then if h then killAnonymousEventHandler(h) end killAnonymousEventHandler(e) cecho("<red>✗ Download failed. Please check your internet connection.<reset>\n") end end) end
```

**Minimal Installation** - For advanced users who want to review the code:

```lua
lua if EMERGE and EMERGE.loaded then cecho("<yellow>EMERGE already loaded (v"..(EMERGE.version or "?")..")<reset>\n") else downloadFile(getMudletHomeDir().."/emerge-manager.lua","https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") registerAnonymousEventHandler("sysDownloadDone",function(e,p) if p:find("emerge%-manager%.lua$") then dofile(p) end end,true) end
```

## Usage

After installation, type `emodule help` for commands.

## License

MIT