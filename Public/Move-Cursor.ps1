function Move-Cursor {
    <#
    .SYNOPSIS
    Moves the cursor through interpolated intermediate positions.

    .DESCRIPTION
    Moves the cursor toward a target by sending real intermediate positions along the way rather
    than teleporting, so hover-driven UI (menus, flyouts) gets the WM_MOUSEMOVE events it needs to
    react. Falls back to an instant Set-Cursor jump when -DurationMilliseconds is 0 or -Steps is 1.

    Accepts either an absolute target (-X/-Y) or an offset from the current position
    (-DeltaX/-DeltaY).

    .PARAMETER X
    Absolute horizontal target coordinate. Used with -Y; cannot be combined with -DeltaX/-DeltaY.

    .PARAMETER Y
    Absolute vertical target coordinate. Used with -X; cannot be combined with -DeltaX/-DeltaY.

    .PARAMETER DeltaX
    Horizontal offset from the current cursor position. Used with -DeltaY; cannot be combined
    with -X/-Y.

    .PARAMETER DeltaY
    Vertical offset from the current cursor position. Used with -DeltaX; cannot be combined with
    -X/-Y.

    .PARAMETER DurationMilliseconds
    Total time to spend moving. 0 jumps straight to the target, like Set-Cursor. Defaults to 300.

    .PARAMETER Steps
    Number of intermediate positions to send along the way. 1 jumps straight to the target.
    Defaults to 30.

    .EXAMPLE
    PS> Move-Cursor -X 500 -Y 40 -DurationMilliseconds 300 -Steps 30
    Glides to (500, 40) over 300ms, so UI that opens on hover (e.g. a menu) has time to react.

    .EXAMPLE
    PS> Move-Cursor -DeltaX 20 -DeltaY -10
    Nudges the cursor 20 pixels right and 10 pixels up from its current position.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Absolute')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Absolute')]
        [int]$X,
        [Parameter(Mandatory, ParameterSetName = 'Absolute')]
        [int]$Y,

        [Parameter(Mandatory, ParameterSetName = 'Relative')]
        [int]$DeltaX,
        [Parameter(Mandatory, ParameterSetName = 'Relative')]
        [int]$DeltaY,

        # Total time to spend moving. 0 (or -Steps 1) jumps straight to the target, like Set-Cursor.
        [int]$DurationMilliseconds = 300,

        # Number of intermediate positions to send along the way, so hover/hit-testing (e.g. opening a
        # menu) has real WM_MOUSEMOVE events to react to instead of a single teleport.
        [int]$Steps = 30
    )

    Process {
        $start = Get-Cursor

        if ($PSCmdlet.ParameterSetName -eq 'Relative') {
            $X = $start.X + $DeltaX
            $Y = $start.Y + $DeltaY
        }

        if ($DurationMilliseconds -le 0 -or $Steps -le 1) {
            Set-Cursor -X $X -Y $Y
            return
        }

        $stepDelay = [Math]::Max(1, [int]($DurationMilliseconds / $Steps))

        for ($i = 1; $i -le $Steps; $i++) {
            $t = $i / $Steps
            $nextX = [int][Math]::Round($start.X + (($X - $start.X) * $t))
            $nextY = [int][Math]::Round($start.Y + (($Y - $start.Y) * $t))
            Set-Cursor -X $nextX -Y $nextY | Out-Null
            Start-Sleep -Milliseconds $stepDelay
        }

        Write-Output "Cursor moved to x: $X, y: $Y (interpolated over $Steps steps)."
    }
}
