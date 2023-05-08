# Hammerspoon External Display Buzzing Fix

This Hammerspoon script fixes the buzzing issue on external displays when waking up from sleep. The script saves the current brightness of the external display when the screens go to sleep and restores the brightness after the screens wake up.

## Requirements

- [Hammerspoon](https://www.hammerspoon.org/)
- [m1ddc](https://github.com/waydabber/m1ddc) (for M1 Macs)

## Installation

- Install Hammerspoon if you haven't already.

- Install m1ddc using Homebrew:

```shell
brew install --cask m1ddc
```

- Clone this repository or copy the `external_display_buzzing_fix.lua` script to your Hammerspoon configuration directory (usually `~/.hammerspoon/`).

- Edit your Hammerspoon `init.lua` file (located in the Hammerspoon configuration directory) and add the following line to load the script:

```lua
require("external_display_buzzing_fix")
```

- Reload your Hammerspoon configuration by clicking the Hammerspoon menu bar icon and selecting "Reload Config".

## Usage

The script runs automatically when the screens go to sleep and wake up. No manual intervention is required.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.txt) file for details.
