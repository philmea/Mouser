function Start-MouseCapture {
    <#
    .SYNOPSIS
    Records live mouse movement and clicks as a sequence.

    .DESCRIPTION
    Polls the cursor position and button state and turns what it sees into Move/MouseDown/MouseUp
    steps in the same shape New-MouseStep produces, so the result plugs straight into
    Invoke-MouseSequence or Export-MouseSequence. A countdown gives you time to get ready before
    recording starts.

    This is a polling capture, not a low-level input hook, so it can't see: clicks/moves faster
    than -SampleIntervalMilliseconds, or scroll wheel input - add Scroll/HorizontalScroll steps by
    hand with New-MouseStep if your sequence needs them.

    .PARAMETER DurationSeconds
    How long to record for, in seconds. Defaults to 10.

    .PARAMETER SampleIntervalMilliseconds
    How often to poll the cursor position and button state, in milliseconds. Defaults to 20.

    .PARAMETER CountdownSeconds
    How long to count down before recording starts, in seconds. Defaults to 3.

    .EXAMPLE
    PS> $captured = Start-MouseCapture -DurationSeconds 10
    Counts down 3 seconds, records for 10 seconds, then returns the captured steps.

    .EXAMPLE
    PS> Start-MouseCapture -DurationSeconds 10 | Export-MouseSequence -Path ./recorded.json
    Records for 10 seconds and saves the result directly to disk.

    .OUTPUTS
    PSCustomObject[] (Mouser.MouseStep)
    #>
    [CmdletBinding()]
    param (
        [int]$DurationSeconds = 10,
        [int]$SampleIntervalMilliseconds = 20,
        [int]$CountdownSeconds = 3
    )

    Process {
        for ($i = $CountdownSeconds; $i -gt 0; $i--) {
            Write-Host "Recording starts in $i..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
        Write-Host "Recording for $DurationSeconds second(s)... move the mouse and click now. (scroll is not captured)" -ForegroundColor Green

        $buttons = @('Left', 'Right', 'Middle')
        $steps = @()

        $lastPos = Get-Cursor
        $lastButtonDown = @{}
        foreach ($button in $buttons) {
            $lastButtonDown[$button] = Get-MouseButtonState -Button $button
        }

        $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
        $lastEventMs = 0

        while ($stopwatch.Elapsed.TotalSeconds -lt $DurationSeconds) {
            Start-Sleep -Milliseconds $SampleIntervalMilliseconds
            $elapsedMs = [int]$stopwatch.Elapsed.TotalMilliseconds

            $pos = Get-Cursor
            if ($pos.X -ne $lastPos.X -or $pos.Y -ne $lastPos.Y) {
                if ($steps.Count -gt 0) {
                    $steps[-1].DelayMilliseconds = [Math]::Max(0, $elapsedMs - $lastEventMs)
                }
                # DurationMilliseconds 0 replays as an instant jump; the recorded delays between
                # samples already reproduce the motion, so re-interpolating on top would double it up.
                $steps += New-MouseStep -Action Move -X $pos.X -Y $pos.Y -DurationMilliseconds 0
                $lastPos = $pos
                $lastEventMs = $elapsedMs
            }

            foreach ($button in $buttons) {
                $isDown = Get-MouseButtonState -Button $button
                if ($isDown -ne $lastButtonDown[$button]) {
                    if ($steps.Count -gt 0) {
                        $steps[-1].DelayMilliseconds = [Math]::Max(0, $elapsedMs - $lastEventMs)
                    }
                    $action = if ($isDown) { 'MouseDown' } else { 'MouseUp' }
                    $steps += New-MouseStep -Action $action -Button $button
                    $lastButtonDown[$button] = $isDown
                    $lastEventMs = $elapsedMs
                }
            }
        }

        Write-Host "Recording complete. Captured $($steps.Count) step(s)." -ForegroundColor Green
        $steps
    }
}
