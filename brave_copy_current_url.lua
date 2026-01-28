-- Cmd-Shift-C: In Brave, copy current tab URL via Accessibility API
-- Reads directly from the address bar UI element (works across all profiles)

hs.hotkey.bind({"cmd","shift"}, "C", function()
    local win = hs.window.focusedWindow()
    if not win then return end
    
    local app = win:application()
    if app and app:name() == "Brave Browser" then
        -- Use accessibility API to find the URL text field
        local axApp = hs.axuielement.applicationElement(app)
        if not axApp then
            hs.alert.show("No AX access", 1)
            return
        end
        
        -- Search for the address bar (AXTextField with AXDescription containing "Address")
        local function findAddressBar(element, depth)
            if depth > 10 then return nil end
            
            local role = element:attributeValue("AXRole")
            local desc = element:attributeValue("AXDescription") or ""
            local roleDesc = element:attributeValue("AXRoleDescription") or ""
            
            -- Look for the URL text field
            if role == "AXTextField" and (desc:find("Address") or desc:find("URL") or roleDesc:find("address")) then
                return element:attributeValue("AXValue")
            end
            
            -- Recurse into children
            local children = element:attributeValue("AXChildren")
            if children then
                for _, child in ipairs(children) do
                    local result = findAddressBar(child, depth + 1)
                    if result then return result end
                end
            end
            return nil
        end
        
        local url = findAddressBar(axApp, 0)
        
        if url and url ~= "" then
            hs.pasteboard.setContents(url)
            hs.alert.show("URL copied", 0.5)
        else
            -- Fallback to keyboard method
            hs.eventtap.keyStroke({"cmd"}, "L", 0)
            hs.timer.doAfter(0.05, function()
                hs.eventtap.keyStroke({"cmd"}, "C", 0)
                hs.timer.doAfter(0.05, function()
                    hs.eventtap.keyStroke({}, "Escape", 0)
                    hs.alert.show("URL copied", 0.5)
                end)
            end)
        end
    else
        hs.eventtap.keyStroke({"cmd","shift"}, "C", 0)
    end
end)
