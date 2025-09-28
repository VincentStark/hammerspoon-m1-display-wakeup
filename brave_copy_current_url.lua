local hotkey = hs.hotkey.bind({"cmd","shift"}, "C", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Brave Browser" then
      local ok, url = hs.osascript.applescript([[
        tell application "Brave Browser"
          if (count of windows) is 0 then return ""
          return URL of active tab of front window
        end tell
      ]])
      if ok and url ~= "" then
        hs.pasteboard.setContents(url)
        hs.alert.show("URL copied")
      else
        hs.alert.show("No URL")
      end
    else
      -- pass through ⌘⇧C to other apps
      hs.eventtap.keyStroke({"cmd","shift"}, "C", 0)
    end
  end)
  