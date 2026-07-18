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

# Left-click once at the current cursor position
Send-Click

# Left-click 3 times, aborting if the cursor moves between clicks
Send-Click -clicks 3 -stationary $true

# Click a specific point in one call - moves there (interpolated via Move-Cursor), then clicks
Send-Click -X 812 -Y 340

# Same idea, any button - Send-Click's -Button covers what used to need three separate cmdlets
Send-Click -X 812 -Y 340 -Button Right
Send-Click -X 812 -Y 340 -Button Middle

# Send-RightClick / Send-MiddleClick still exist as readable shorthand for the common cases -
# they just forward to Send-Click now
Send-RightClick -X 812 -Y 340
Send-MiddleClick

# Double-click once, timed to the OS double-click interval - also takes -X/-Y
Send-DoubleClick -X 812 -Y 340

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

# Nudge the cursor by an offset instead of an absolute position
Move-Cursor -DeltaX 20 -DeltaY -10

# Where's the desktop, in case you're working across multiple monitors?
Get-ScreenResolution

# What color is this pixel? Useful for "wait until this button lit up" style checks before clicking
Get-PixelColor -X 812 -Y 340
```

### Sequences

Build a reusable series of moves and clicks with `New-MouseStep`, then play it back with
`Invoke-MouseSequence`. Passing `-X`/`-Y` to a `Click`/`RightClick`/`MiddleClick`/`DoubleClick`
step moves there first (interpolated through `Move-Cursor`, same as a standalone `Move` step) and
then clicks - one step instead of a separate `Move` + `Click` pair for what's really one action.
That interpolation is also what lets a sequence walk through a menu and click a submenu item; a
teleport would skip past the hover states that open it.

```powershell
$sequence = @(
    New-MouseStep -Action Click -X 100 -Y 40 -DelayMilliseconds 150   # open the top-level menu
    New-MouseStep -Action Click -X 100 -Y 90                          # hover + click a submenu item
)

$sequence | Invoke-MouseSequence

# Run it 3 times in a row
$sequence | Invoke-MouseSequence -Repeat 3

# Or run it on a timer instead of a fixed count - loops until 5 minutes have elapsed.
# Checked between laps, not mid-sequence, so it can run a little past 5 minutes rather
# than being cut off mid-step (e.g. mid-drag).
$sequence | Invoke-MouseSequence -DurationSeconds 300

# Save it for later, then replay straight from disk
$sequence | Export-MouseSequence -Path ./open-menu.json
Invoke-MouseSequence -Path ./open-menu.json
```

### Composing sequences

`Invoke-MouseSequence` only knows how to run one sequence at a time, on purpose - switching
between sequences on a schedule (e.g. "loop A for 5 minutes, run B once, then go back to looping
A") is workflow-specific orchestration, not a mouse-automation primitive, so it belongs in a small
wrapper script around the module rather than in the module itself:

```powershell
Import-Module ./Mouser.psd1

$sequenceA = Import-MouseSequence -Path ./sequence-a.json
$sequenceB = Import-MouseSequence -Path ./sequence-b.json

while ($true) {
    $sequenceA | Invoke-MouseSequence -DurationSeconds 300
    $sequenceB | Invoke-MouseSequence
}
```

`Export-MouseSequence` writes an envelope object rather than a bare array, so the on-disk shape is
stable no matter how many steps it holds (a bare array would serialize a single step as `{...}`
instead of `[{...}]`, which `Import-MouseSequence` has to account for either way):

```json
{
    "Version": 1,
    "ExportedAt": "2026-07-16T18:23:00.0000000Z",
    "StepCount": 2,
    "Steps": [
        { "Action": "Click", "X": 100, "Y": 40, "DurationMilliseconds": 300, "Steps": 30, "Clicks": 1, "Stationary": false, "Button": "Left", "Amount": 120, "DelayMilliseconds": 150 },
        { "Action": "Click", "X": 100, "Y": 90, "DurationMilliseconds": 300, "Steps": 30, "Clicks": 1, "Stationary": false, "Button": "Left", "Amount": 120, "DelayMilliseconds": 0 }
    ]
}
```

### Capturing a sequence instead of writing one

Most people would rather record what they actually do than hand-author a list of coordinates.
`Start-MouseCapture` polls the cursor position and button state and turns what it sees into the
same step objects `New-MouseStep` produces, so the output plugs straight into
`Invoke-MouseSequence` and `Export-MouseSequence`:

```powershell
# 3-second countdown, then records for 10 seconds
$captured = Start-MouseCapture -DurationSeconds 10

# Replay it immediately, or save it for later
$captured | Invoke-MouseSequence
$captured | Export-MouseSequence -Path ./recorded.json
```

It's a polling capture, not a low-level input hook, so two things it can't see: clicks/moves
faster than `-SampleIntervalMilliseconds` (default 20ms), and scroll wheel input — add
`Scroll`/`HorizontalScroll` steps by hand with `New-MouseStep` if your sequence needs them.

## Cmdlets

| Cmdlet | Description |
| --- | --- |
| `Get-Cursor` | Returns the current cursor position as `@{ x = ..; y = .. }`. |
| `Set-Cursor` | Moves the cursor to the given `x`/`y` coordinates. |
| `Send-Click` | Sends one or more mouse clicks (`-Button Left\|Right\|Middle`) at the current cursor position, or at `-X`/`-Y` if given (moves there first). |
| `Send-RightClick` | Shorthand for `Send-Click -Button Right`. |
| `Send-MiddleClick` | Shorthand for `Send-Click -Button Middle`. |
| `Send-DoubleClick` | Sends one or more left double-clicks, timed to the OS double-click interval. Also takes `-X`/`-Y`. |
| `Send-MouseDown` | Presses and holds a mouse button (`-Button Left\|Right\|Middle`) without releasing it. |
| `Send-MouseUp` | Releases a previously pressed mouse button (`-Button Left\|Right\|Middle`). |
| `Send-Scroll` | Sends a vertical mouse wheel event (`-Amount`, in multiples of 120 = one notch). |
| `Send-HorizontalScroll` | Sends a horizontal mouse wheel event (`-Amount`, in multiples of 120 = one notch). |
| `Move-Cursor` | Moves the cursor to `-X`/`-Y` (or by an offset via `-DeltaX`/`-DeltaY`) through interpolated intermediate positions instead of a teleport, so hover-driven UI (menus, flyouts) tracks the movement. |
| `Get-ScreenResolution` | Returns the full virtual desktop bounds (`X`, `Y`, `Width`, `Height`) across every monitor. |
| `Get-PixelColor` | Returns the RGB/hex color of the pixel at `-X`/`-Y`, for verify-before-click checks. |
| `New-MouseStep` | Builds a single step (`Move`, `Click`, `RightClick`, `MiddleClick`, `DoubleClick`, `MouseDown`, `MouseUp`, `Scroll`, `HorizontalScroll`, `Wait`) for use with `Invoke-MouseSequence`. `-X`/`-Y` apply to `Move` and to the click actions (move there first, then click). |
| `Invoke-MouseSequence` | Plays back an array of steps (piped in, or loaded via `-Path`) in order, either `-Repeat`ed a fixed number of times or looped for `-DurationSeconds`. |
| `Export-MouseSequence` | Saves a step array to a JSON file as a `{ Version, ExportedAt, StepCount, Steps }` envelope. |
| `Import-MouseSequence` | Loads a step array back from a JSON file written by `Export-MouseSequence`. |
| `Get-MouseButtonState` | Returns `$true`/`$false` for whether a button (`-Button Left\|Right\|Middle`) is currently held down. |
| `Start-MouseCapture` | Records live mouse movement/clicks for `-DurationSeconds` and returns them as a step array, ready for `Invoke-MouseSequence` or `Export-MouseSequence`. |

## Project layout

```
Mouser.psd1     # module manifest
Mouser.psm1     # root module, dot-sources Public/Private functions and exports the public ones
Public/         # one file per exported cmdlet
Private/        # internal helper functions (e.g. the shared user32.dll mouse_event wrapper)
```
