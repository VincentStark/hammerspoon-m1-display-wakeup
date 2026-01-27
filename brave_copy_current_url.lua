-- Cmd-Shift-C: In Brave, copy current tab URL
-- Uses keyboard shortcuts (works across all profiles)

hs.hotkey.bind({"cmd","shift"}, "C", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Brave Browser" then
      -- Cmd+L focuses address bar and selects URL
      hs.eventtap.keyStroke({"cmd"}, "L", 0)
      hs.timer.usleep(100000) -- 100ms
      
      -- Cmd+C copies the selected URL
      hs.eventtap.keyStroke({"cmd"}, "C", 0)
      hs.timer.usleep(100000) -- 100ms
      
      -- Escape to return focus to page
      hs.eventtap.keyStroke({}, "Escape", 0)
    else
      -- pass through ⌘⇧C to other apps
      hs.eventtap.keyStroke({"cmd","shift"}, "C", 0)
    end
  end)
