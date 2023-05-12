-- Fix external display buzzing if not 100% brightness on wake up
watcher = hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.screensDidWake then
        -- Restore previous brightness after a delay
        hs.timer.doAfter(2.5, function()
            local prevBrightness = hs.execute("/opt/homebrew/bin/m1ddc get luminance")
            hs.execute("/opt/homebrew/bin/m1ddc set luminance 100")
            if tonumber(prevBrightness) < 100 then
                hs.timer.doAfter(0.5, function()
                    hs.execute("/opt/homebrew/bin/m1ddc set luminance " .. prevBrightness)
                end)
            end
        end)
    end
end)

watcher:start()
