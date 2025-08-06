# EMERGE

Module Manager for the EMERGE Achaea System

## Quick Install

Copy and paste this command into Mudlet:

```lua
lua local f=getMudletHomeDir().."/emerge-manager.lua" downloadFile(f,"https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") cecho("<yellow>\n[EMERGE] Downloading...<reset>\n") local h,e h=registerAnonymousEventHandler("sysDownloadDone",function(ev,p) if p==f then killAnonymousEventHandler(h) if e then killAnonymousEventHandler(e) end cecho("<green>[EMERGE] Download complete! Loading...<reset>\n") local x,r=pcall(dofile,p) if x then cecho("<green>[EMERGE] ✓ Success! Type 'emodule help' to start<reset>\n") else cecho("<red>[EMERGE] Load error: "..(r or "?").."<reset>\n") end end end) e=registerAnonymousEventHandler("sysDownloadError",function(ev,p) if p==f then killAnonymousEventHandler(h) killAnonymousEventHandler(e) cecho("<red>[EMERGE] Download failed. Check internet connection.<reset>\n") end end)
```

## Usage

After installation, type `emodule help` for commands.

## License

MIT