-- Hammerspoon: Caffeinate-on-AC (no external process)
-- Uses hs.caffeinate.set() to assert displayIdle on AC only.

local menu = hs.menubar.new()

local function onAC()
  return hs.battery.powerSource() == "AC Power"
end

local function setAssertions(enable)
  hs.caffeinate.set("displayIdle", enable)
  hs.caffeinate.set("systemIdle", enable)
  hs.caffeinate.set("system", enable)
end

local function refreshMenu()
  if not menu then return end
  if onAC() then
    menu:setTitle("●")
    menu:setTooltip("caffeinate: ON (AC) — displayIdle asserted")
  else
    menu:setTitle("○")
    menu:setTooltip("caffeinate: OFF (Battery)")
  end
end

local function applyPolicy()
  if onAC() then
    setAssertions(true)
    hs.alert.show("caffeinate: ON (AC)")
  else
    setAssertions(false)
    hs.alert.show("caffeinate: OFF (Battery)")
  end
  refreshMenu()
  -- Debug: print current assertions to the console
  hs.printf("Assertions: %s", hs.inspect(hs.caffeinate.currentAssertions()))
end

-- Apply once after launch (reload/boot). Small delay lets powerSource settle.
hs.timer.doAfter(1, applyPolicy)

-- React to plug/unplug changes
local pw = hs.battery.watcher.new(applyPolicy)
pw:start()

refreshMenu()
