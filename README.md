# Mouser

A PowerShell module for Windows mouse automation — read and set cursor position, and send clicks.

## Requirements

- Windows (uses `System.Windows.Forms` and `user32.dll`)
- PowerShell 5.1 or PowerShell 7+ (Core)

## Install

```powershell
Import-Module ./Mouser.psd1
```

## Usage

```powershell
# Get the current cursor position
Get-Cursor

# Move the cursor
Set-Cursor -x 500 -y 300

# Left-click once
Send-Click

# Left-click 3 times, aborting if the cursor moves between clicks
Send-Click -clicks 3 -stationary $true

# Right-click once
Send-RightClick
```

## Cmdlets

| Cmdlet | Description |
| --- | --- |
| `Get-Cursor` | Returns the current cursor position as `@{ x = ..; y = .. }`. |
| `Set-Cursor` | Moves the cursor to the given `x`/`y` coordinates. |
| `Send-Click` | Sends one or more left mouse clicks at the current cursor position. |
| `Send-RightClick` | Sends one or more right mouse clicks at the current cursor position. |

## Project layout

```
Mouser.psd1     # module manifest
Mouser.psm1     # root module, dot-sources Public/Private functions and exports the public ones
Public/         # one file per exported cmdlet
Private/        # internal helper functions (e.g. the shared user32.dll mouse_event wrapper)
```
