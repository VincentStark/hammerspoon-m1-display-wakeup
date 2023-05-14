-- Fix external display buzzing if not 100% brightness on wake up
watcher = hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.screensDidWake then
        -- Restore previous brightness after a delay
        hs.timer.doAfter(2.0, function()
            local prevBrightness = hs.execute("/opt/homebrew/bin/m1ddc get luminance")
            hs.execute("/opt/homebrew/bin/m1ddc set luminance 100")
            prevBrightness = tonumber(prevBrightness)
            if prevBrightness < 100 then
                if prevBrightness < 60 then
                    prevBrightness = 60
                end
                hs.execute("/opt/homebrew/bin/m1ddc set luminance " .. prevBrightness)
            end
        end)
    end
end)

watcher:start()
