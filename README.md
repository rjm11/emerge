# EMERGE

Module Manager for the EMERGE Achaea System

## Quick Install

Copy and paste this command into Mudlet:

```lua
lua local f=getMudletHomeDir().."/emerge-dl.lua" downloadFile(f,"https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") cecho("<yellow>\n[EMERGE] Downloading...<reset>\n") local h h=registerAnonymousEventHandler("sysDownloadDone",function(e,p) if p==f then killAnonymousEventHandler(h) cecho("<green>[EMERGE] Download complete! Loading...<reset>\n") local x,r=pcall(dofile,p) if x then cecho("<green>[EMERGE] Success! Type 'emodule help' to start<reset>\n") else cecho("<red>[EMERGE] Load error: "..(r or "?").."<reset>\n") end os.remove(p) end end) registerAnonymousEventHandler("sysDownloadError",function(e,p) if p==f then cecho("<red>[EMERGE] Download failed. Check internet connection.<reset>\n") end end,true)
```

## Usage

After installation, type `emodule help` for commands.

## License

MIT