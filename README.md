# EMERGE

Module Manager for the EMERGE Achaea System

## Quick Install

Copy and paste this command into Mudlet:

```lua
lua cecho("<yellow>\n========== EMERGE INSTALLER ==========<reset>\n") local f=getMudletHomeDir().."/emerge-manager.lua" cecho("<yellow>Target: "..f.."<reset>\n") cecho("<yellow>Downloading from GitHub...<reset>\n") downloadFile(f,"https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") local h,e h=registerAnonymousEventHandler("sysDownloadDone",function(ev,p) if p==f then killAnonymousEventHandler(h) if e then killAnonymousEventHandler(e) end cecho("<green>Download complete! Loading EMERGE...<reset>\n") local x,r=pcall(dofile,p) if x then cecho("<green>✓ EMERGE loaded successfully!<reset>\n") cecho("<yellow>Type 'emodule help' for commands<reset>\n") else cecho("<red>Load error: "..(r or "unknown").."<reset>\n") end end end) e=registerAnonymousEventHandler("sysDownloadError",function(ev,p) if p==f then if h then killAnonymousEventHandler(h) end killAnonymousEventHandler(e) cecho("<red>Download failed! Check your internet connection<reset>\n") end end) cecho("<DimGrey>Waiting for download to complete...<reset>\n")
```

## Usage

After installation, type `emodule help` for commands.

## License

MIT