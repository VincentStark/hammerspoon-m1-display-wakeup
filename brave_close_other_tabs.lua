-- Cmd-Shift-M: In Brave, close other tabs (leave active tab; keep pinned tabs)
-- Fixed for multiple profiles: matches by actual focused window title

local function braveCloseOtherTabs()
    -- Get the actual focused window title from Hammerspoon (reliable)
    local focusedWin = hs.window.focusedWindow()
    if not focusedWin then
      return false, "no-window"
    end
    local focusedTitle = focusedWin:title()
    if not focusedTitle or focusedTitle == "" then
      return false, "no-title"
    end

    -- Strip " - Brave" suffix (Hammerspoon includes it, AppleScript doesn't)
    local titleForMatch = focusedTitle:gsub(" %- Brave$", "")
    
    -- Escape the title for AppleScript (double quotes and backslashes)
    local escapedTitle = titleForMatch:gsub("\\", "\\\\"):gsub('"', '\\"')

    local script = [[
      tell application "Brave Browser"
        set windowCount to count of windows
        if windowCount is 0 then return "no-window"
        
        set targetTitle to "]] .. escapedTitle .. [["
        set targetWindow to missing value
        
        -- Find window matching the focused title (exact match first)
        repeat with w in windows
          if name of w is targetTitle then
            set targetWindow to w
            exit repeat
          end if
        end repeat
        
        -- Fallback: partial match (in case of minor differences)
        if targetWindow is missing value then
          repeat with w in windows
            if name of w contains targetTitle or targetTitle contains name of w then
              set targetWindow to w
              exit repeat
            end if
          end repeat
        end if
        
        if targetWindow is missing value then return "window-not-found"
        
        set tabCount to count of tabs of targetWindow
        if tabCount ≤ 1 then return "nothing"
        
        set keepPinned to true
        set idx to active tab index of targetWindow
        
        repeat with i from tabCount to 1 by -1
          if i is not idx then
            set t to tab i of targetWindow
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
      elseif res == "no-title" then
        hs.alert.show("Could not get window title")
      elseif res == "window-not-found" then
        -- This can happen with isolated profiles (e.g., Clawdbot browser)
        -- that run with separate user-data-dir
        hs.alert.show("Window not accessible (separate profile?)")
      end
      -- success ("done") shows nothing
    else
      -- not Brave: pass-through ⌘⇧M
      hs.eventtap.keyStroke({"cmd","shift"}, "M", 0)
    end
  end)
