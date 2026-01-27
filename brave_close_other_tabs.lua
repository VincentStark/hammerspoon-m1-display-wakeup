-- Cmd-Shift-M: In Brave, close other tabs via Tab menu
-- Uses System Events UI automation (works across all profiles)

local function braveCloseOtherTabs()
    local script = [[
      tell application "System Events"
        tell process "Brave Browser"
          try
            click menu item "Close Other Tabs" of menu "Tab" of menu bar 1
            return "done"
          on error errMsg
            return "error: " & errMsg
          end try
        end tell
      end tell
    ]]
    return hs.osascript.applescript(script)
  end
  
  hs.hotkey.bind({"cmd","shift"}, "M", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Brave Browser" then
      local ok, res = braveCloseOtherTabs()
      if not ok then
        hs.alert.show("Error: " .. tostring(res))
      elseif res == "done" then
        -- success, no alert needed
      elseif res:match("^error:") then
        hs.alert.show(res)
      end
    else
      -- not Brave: pass-through ⌘⇧M
      hs.eventtap.keyStroke({"cmd","shift"}, "M", 0)
    end
  end)
