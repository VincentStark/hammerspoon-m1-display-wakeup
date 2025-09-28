-- Bind Ctrl+Alt+Cmd+1 to: ~/go/bin/gbmonctl -prop kvm-switch -val 1
local function runGbmon(val)
    local bin = (os.getenv("HOME") or "") .. "/go/bin/gbmonctl"
  
    if not hs.fs.attributes(bin) then
      hs.alert.show("gbmonctl not found at: " .. bin)
      return
    end
  
    hs.task.new(bin, function(exitCode, stdout, stderr)
      if exitCode == 0 then
        hs.notify.new({ title = "KVM Switch", informativeText = "Set kvm-switch → " .. tostring(val) }):send()
      else
        hs.notify.new({
          title = "gbmonctl failed (" .. tostring(exitCode) .. ")",
          informativeText = (stderr ~= "" and stderr) or (stdout ~= "" and stdout) or "Unknown error",
        }):send()
        hs.alert.show("gbmonctl failed — see notification")
      end
    end, {"-prop", "kvm-switch", "-val", tostring(val)}):start()
  end
  
  -- Ctrl+Alt+Cmd+1 → set to 1
  hs.hotkey.bind({"ctrl","shift"}, "1", function() runGbmon(1) end)
  