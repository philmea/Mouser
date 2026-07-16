function Start-MouseCapture {
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
            if ($pos.x -ne $lastPos.x -or $pos.y -ne $lastPos.y) {
                if ($steps.Count -gt 0) {
                    $steps[-1].DelayMilliseconds = [Math]::Max(0, $elapsedMs - $lastEventMs)
                }
                # DurationMilliseconds 0 replays as an instant jump; the recorded delays between
                # samples already reproduce the motion, so re-interpolating on top would double it up.
                $steps += New-MouseStep -Action Move -X $pos.x -Y $pos.y -DurationMilliseconds 0
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
