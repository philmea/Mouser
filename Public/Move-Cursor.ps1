function Move-Cursor {
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
