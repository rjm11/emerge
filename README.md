# EMERGE

Module Manager for the EMERGE Achaea System

## Quick Install

Copy and paste this command into Mudlet:

```lua
lua downloadFile(getMudletHomeDir().."/emerge-dl.lua","https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua") cecho("<yellow>\n[EMERGE] Downloading...<reset>\n") registerAnonymousEventHandler("sysDownloadDone",function(e,f) if f:find("emerge%-dl%.lua$") then cecho("<green>[EMERGE] Download complete! Loading...<reset>\n") local x,r=pcall(dofile,f) if x then cecho("<green>[EMERGE] Success! Type 'emodule help' to start<reset>\n") else cecho("<red>[EMERGE] Load error: "..(r or "?").."<reset>\n") end os.remove(f) end end,true) registerAnonymousEventHandler("sysDownloadError",function(e,f) if f:find("emerge%-dl%.lua$") then cecho("<red>[EMERGE] Download failed. Check internet connection.<reset>\n") end end,true)
```

## Usage

After installation, type `emodule help` for commands.

## License

MIT