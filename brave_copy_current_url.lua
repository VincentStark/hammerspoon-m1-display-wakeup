-- Cmd-Shift-C: In Brave, copy current tab URL
-- Uses keyboard shortcuts (works across all profiles)

hs.hotkey.bind({"cmd","shift"}, "C", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Brave Browser" then
      -- Save current pasteboard to detect if copy worked
      local oldClipboard = hs.pasteboard.getContents()
      
      -- Cmd+L focuses address bar and selects URL
      hs.eventtap.keyStroke({"cmd"}, "L", 0)
      hs.timer.usleep(50000) -- 50ms wait
      
      -- Cmd+C copies
      hs.eventtap.keyStroke({"cmd"}, "C", 0)
      hs.timer.usleep(50000) -- 50ms wait
      
      -- Escape to return focus to page
      hs.eventtap.keyStroke({}, "Escape", 0)
      
      -- Check if we got a URL
      local newClipboard = hs.pasteboard.getContents()
      if newClipboard and newClipboard ~= oldClipboard and newClipboard:match("^https?://") then
        hs.alert.show("URL copied")
      elseif newClipboard and newClipboard:match("^file://") then
        hs.alert.show("URL copied")
      elseif newClipboard and newClipboard:match("^brave://") then
        hs.alert.show("URL copied")
      else
        hs.alert.show("Copied")
      end
    else
      -- pass through ⌘⇧C to other apps
      hs.eventtap.keyStroke({"cmd","shift"}, "C", 0)
    end
  end)
