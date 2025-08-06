-- EMERGE One-Click Installer
-- This file contains the improved installer that properly sets up persistence

local function installEMERGE()
  local manager_file = getMudletHomeDir() .. "/emerge-manager.lua"
  local temp_file = getMudletHomeDir() .. "/emerge-dl-temp.lua"
  
  cecho("<yellow>\n[EMERGE] Starting installation...<reset>\n")
  
  -- Download the manager file
  downloadFile(temp_file, "https://raw.githubusercontent.com/rjm11/emerge/main/emerge-manager.lua")
  
  local download_handler
  local error_handler
  
  download_handler = registerAnonymousEventHandler("sysDownloadDone", function(event, filepath)
    if filepath == temp_file then
      killAnonymousEventHandler(download_handler)
      if error_handler then killAnonymousEventHandler(error_handler) end
      
      cecho("<green>[EMERGE] Download complete!<reset>\n")
      
      -- Read the downloaded content
      local f = io.open(temp_file, "r")
      if f then
        local content = f:read("*all")
        f:close()
        
        -- Write to the permanent location
        local out = io.open(manager_file, "w")
        if out then
          out:write(content)
          out:close()
          cecho("<green>[EMERGE] Manager saved to permanent location<reset>\n")
          
          -- Clean up temp file
          os.remove(temp_file)
          
          -- Now load the manager
          cecho("<green>[EMERGE] Loading EMERGE...<reset>\n")
          local ok, err = pcall(dofile, manager_file)
          
          if ok then
            cecho("<green>[EMERGE] ✓ Installation successful!<reset>\n")
            cecho("<LightSteelBlue>[EMERGE] Type 'emodule help' to see available commands<reset>\n")
            
            -- The manager will create its own persistent loader
          else
            cecho("<red>[EMERGE] Load error: " .. (err or "unknown") .. "<reset>\n")
          end
        else
          cecho("<red>[EMERGE] Failed to save manager file<reset>\n")
        end
      else
        cecho("<red>[EMERGE] Failed to read downloaded file<reset>\n")
      end
    end
  end)
  
  error_handler = registerAnonymousEventHandler("sysDownloadError", function(event, filepath, errorMsg)
    if filepath == temp_file then
      killAnonymousEventHandler(download_handler)
      killAnonymousEventHandler(error_handler)
      cecho("<red>[EMERGE] Download failed: " .. (errorMsg or "Check internet connection") .. "<reset>\n")
    end
  end)
end

-- Run the installer
installEMERGE()