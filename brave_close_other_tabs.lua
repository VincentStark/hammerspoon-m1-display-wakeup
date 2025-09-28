-- Cmd-Shift-M: In Brave, close other tabs (leave active tab; keep pinned tabs)
-- Change keepPinned to false if you want to close pinned tabs too.

local function braveCloseOtherTabs()
    local script = [[
      tell application "Brave Browser"
        if (count of windows) is 0 then return "no-window"
        set w to front window
        set tabCount to count of tabs of w
        if tabCount ≤ 1 then return "nothing"
        set keepPinned to true
  
        set idx to active tab index of w
        repeat with i from tabCount to 1 by -1
          if i is not idx then
            set t to tab i of w
            set isPinned to false
            try
              set isPinned to pinned of t
            end try
            if (keepPinned is false) or (isPinned is false) then
              close t
            end if
          end if
        end repeat
        return "done"
      end tell
    ]]
    return hs.osascript.applescript(script)
  end
  
  hs.hotkey.bind({"cmd","shift"}, "M", function()
    local app = hs.application.frontmostApplication()
    if app and app:name() == "Brave Browser" then
      local ok, res = braveCloseOtherTabs()
      if not ok then
        hs.alert.show("Error closing tabs")
      elseif res == "nothing" then
        hs.alert.show("Only one tab")
      elseif res == "no-window" then
        hs.alert.show("No Brave window")
      end
      -- success ("done") shows nothing; keystroke swallowed
    else
      -- not Brave: pass-through ⌘⇧M
      hs.eventtap.keyStroke({"cmd","shift"}, "M", 0)
    end
  end)
  