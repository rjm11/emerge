--[[
EMERGE GMCP Normalization Module
Translates raw Mudlet GMCP events into stable `gmcp.*` events.
]]

local MODULE_NAME = "emerge-gmcp"
local MODULE_VERSION = "0.1.0"

local M = {
  name = MODULE_NAME,
  version = MODULE_VERSION,
  handlers = {},
  last = { affs = {} }
}

local function boolstr(v)
  if v == true then return true end
  if v == false then return false end
  if v == '1' or v == 1 then return true end
  if v == '0' or v == 0 then return false end
  return v and true or false
end

function M:init()
  -- Provide capability for others to require
  if emerge and emerge.capabilities then
    emerge.capabilities.provide('gmcp.normalized', { version = MODULE_VERSION, module = MODULE_NAME })
  end

  -- Vitals normalization (debounced ~75ms)
  self.handlers.vitals = registerAnonymousEventHandler("gmcp.Char.Vitals", function()
    local v = gmcp and gmcp.Char and gmcp.Char.Vitals or {}
    local payload = {
      hp = tonumber(v.hp), maxhp = tonumber(v.maxhp),
      mp = tonumber(v.mp), maxmp = tonumber(v.maxmp),
      ep = tonumber(v.ep), maxep = tonumber(v.maxep),
      wp = tonumber(v.wp), maxwp = tonumber(v.maxwp),
      bal = boolstr(v.balance), eq = boolstr(v.equilibrium),
      ts = os.time()
    }
    if emerge and emerge.events and emerge.events.debounce then
      -- Coalesce bursts
      if not self._vitals_db_id then
        self._vitals_db_id = emerge.events.debounce('emerge.__gmcp.vitals.internal', function()
          emerge.events.emit('gmcp.char.vitals', payload)
        end, 75)
      end
      -- Trigger internal event for debounce pipeline
      emerge.events.emit('emerge.__gmcp.vitals.internal')
    else
      -- Fallback: emit directly
      raiseEvent('gmcp.char.vitals', payload)
    end
  end)

  -- Afflictions list normalization + delta computation
  self.handlers.affs = registerAnonymousEventHandler("gmcp.Char.Afflictions.List", function()
    local a = gmcp and gmcp.Char and gmcp.Char.Afflictions and gmcp.Char.Afflictions.List or {}
    local list = {}
    for _, it in ipairs(a) do list[#list+1] = tostring(it) end
    local prev = {}
    for x in pairs(self.last.affs) do prev[x] = true end
    local now = {}
    for _, x in ipairs(list) do now[x] = true end
    local gained, lost = {}, {}
    for x in pairs(now) do if not prev[x] then gained[#gained+1] = x end end
    for x in pairs(prev) do if not now[x] then lost[#lost+1] = x end end
    self.last.affs = now
    local payload = { list = list, gained = (#gained>0) and gained or nil, lost = (#lost>0) and lost or nil, ts = os.time() }
    if emerge and emerge.events then
      emerge.events.emit('gmcp.char.afflictions', payload)
    else
      raiseEvent('gmcp.char.afflictions', payload)
    end
  end)
end

function M:unload()
  for _, id in pairs(self.handlers) do
    if id then pcall(killAnonymousEventHandler, id) end
  end
  if self._vitals_db_id and emerge and emerge.events then
    pcall(emerge.events.off, 'emerge.__gmcp.vitals.internal', self._vitals_db_id)
  end
end

if EMERGE then
  -- Ensure any previous instance is unloaded cleanly
  if EMERGE.modules[MODULE_NAME] and EMERGE.modules[MODULE_NAME].unload then
    EMERGE.modules[MODULE_NAME]:unload()
  end
  M:init()
  EMERGE:register(MODULE_NAME, M)
else
  cecho("<IndianRed>EMERGE manager not found; install the manager first.<reset>\n")
  return nil
end

return M

