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

# Move smoothly (30 intermediate positions over 300ms), so hover-triggered UI
# (menus, flyouts) has real mouse-move events to react to instead of a teleport
Move-Cursor -X 500 -Y 40 -DurationMilliseconds 300 -Steps 30
```

### Sequences

Build a reusable series of moves and clicks with `New-MouseStep`, then play it back with
`Invoke-MouseSequence`. `Move` steps interpolate through `Move-Cursor` by default, which is what
lets a sequence walk through a menu and click a submenu item — a teleport would skip past the
hover states that open it.

```powershell
$sequence = @(
    New-MouseStep -Action Move -X 100 -Y 40 -DelayMilliseconds 150   # open top-level menu
    New-MouseStep -Action Click
    New-MouseStep -Action Move -X 100 -Y 90 -DelayMilliseconds 150   # hover a submenu item
    New-MouseStep -Action Click
)

$sequence | Invoke-MouseSequence

# Run it 3 times in a row
$sequence | Invoke-MouseSequence -Repeat 3

# Save it for later, then replay straight from disk
$sequence | Export-MouseSequence -Path ./open-menu.json
Invoke-MouseSequence -Path ./open-menu.json
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
| `Move-Cursor` | Moves the cursor to `-X`/`-Y` through interpolated intermediate positions instead of a teleport, so hover-driven UI (menus, flyouts) tracks the movement. |
| `New-MouseStep` | Builds a single step (`Move`, `Click`, `RightClick`, `MiddleClick`, `DoubleClick`, `MouseDown`, `MouseUp`, `Scroll`, `HorizontalScroll`, `Wait`) for use with `Invoke-MouseSequence`. |
| `Invoke-MouseSequence` | Plays back an array of steps (piped in, or loaded via `-Path`) in order, optionally `-Repeat`ed. |
| `Export-MouseSequence` | Saves a step array to a JSON file. |
| `Import-MouseSequence` | Loads a step array back from a JSON file. |

## Project layout

```
Mouser.psd1     # module manifest
Mouser.psm1     # root module, dot-sources Public/Private functions and exports the public ones
Public/         # one file per exported cmdlet
Private/        # internal helper functions (e.g. the shared user32.dll mouse_event wrapper)
```
