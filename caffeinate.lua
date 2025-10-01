-- Caffeinate-on-AC for clamshell/KVM setups
-- Starts/stops `caffeinate -d` based on power source.
-- Also runs the correct state at boot/login.

local caffeinateTask = nil

local function isOnAC()
  -- Returns "AC Power" or "Battery Power"
  return hs.battery.powerSource() == "AC Power"
end

local function startCaffeinate()
  if caffeinateTask and caffeinateTask:isRunning() then return end
  -- Kill any orphaned caffeinate processes and start new one after completion
  hs.task.new("/usr/bin/killall", function()
    -- This callback runs when killall completes
    caffeinateTask = hs.task.new("/usr/bin/caffeinate", function()
        caffeinateTask = nil
    end, {"-dims"})
    caffeinateTask:start()
    hs.alert.show("caffeinate: ON (AC)")
  end, {"-q", "caffeinate"}):start()
end

local function stopCaffeinate()
  if caffeinateTask and caffeinateTask:isRunning() then
    caffeinateTask:terminate()
    caffeinateTask = nil
  end
  -- Ensure nothing lingering
  hs.task.new("/usr/bin/killall", nil, {"-q", "caffeinate"}):start()
  hs.alert.show("caffeinate: OFF (Battery)")
end

local function applyPowerPolicy()
  if isOnAC() then startCaffeinate() else stopCaffeinate() end
end

-- Run once on Hammerspoon launch (covers reboot/login)
applyPowerPolicy()

-- Watch for power changes (plug/unplug)
local powerWatcher = hs.battery.watcher.new(function()
  applyPowerPolicy()
end)
powerWatcher:start()
