# Mouser

A PowerShell module for Windows mouse automation — read and set cursor position, send clicks, and scroll.

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

# Middle-click once
Send-MiddleClick

# Double-click once
Send-DoubleClick

# Press and hold the left button, move, then release (manual drag)
Send-MouseDown -Button Left
Set-Cursor -x 800 -y 400
Send-MouseUp -Button Left

# Scroll up one notch, then down two notches
Send-Scroll -Amount 120
Send-Scroll -Amount -240

# Scroll right one notch
Send-HorizontalScroll -Amount 120
```

## Cmdlets

| Cmdlet | Description |
| --- | --- |
| `Get-Cursor` | Returns the current cursor position as `@{ x = ..; y = .. }`. |
| `Set-Cursor` | Moves the cursor to the given `x`/`y` coordinates. |
| `Send-Click` | Sends one or more left mouse clicks at the current cursor position. |
| `Send-RightClick` | Sends one or more right mouse clicks at the current cursor position. |
| `Send-MiddleClick` | Sends one or more middle mouse clicks at the current cursor position. |
| `Send-DoubleClick` | Sends one or more left double-clicks, timed to the OS double-click interval. |
| `Send-MouseDown` | Presses and holds a mouse button (`-Button Left\|Right\|Middle`) without releasing it. |
| `Send-MouseUp` | Releases a previously pressed mouse button (`-Button Left\|Right\|Middle`). |
| `Send-Scroll` | Sends a vertical mouse wheel event (`-Amount`, in multiples of 120 = one notch). |
| `Send-HorizontalScroll` | Sends a horizontal mouse wheel event (`-Amount`, in multiples of 120 = one notch). |

## Project layout

```
Mouser.psd1     # module manifest
Mouser.psm1     # root module, dot-sources Public/Private functions and exports the public ones
Public/         # one file per exported cmdlet
Private/        # internal helper functions (e.g. the shared user32.dll mouse_event wrapper)
```
