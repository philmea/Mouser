function Invoke-MouseSequence {
    <#
    .SYNOPSIS
    Plays back a series of mouse steps.

    .DESCRIPTION
    Runs each step in a sequence - built with New-MouseStep, or loaded from a JSON file written by
    Export-MouseSequence - dispatching it to the matching cmdlet (Move-Cursor, Send-Click,
    Send-MouseDown, Send-Scroll, etc.) in order.

    The sequence can be repeated a fixed number of times (-Repeat), or looped until a given amount
    of wall-clock time has elapsed (-DurationSeconds). This cmdlet only runs one sequence at a
    time; switching between sequences on a schedule (e.g. loop A for 5 minutes, then run B once)
    is workflow-specific orchestration that belongs in a wrapper script around this cmdlet rather
    than in the module itself.

    .PARAMETER Steps
    The steps to play back, typically piped in from New-MouseStep or Start-MouseCapture.

    .PARAMETER Path
    Path to a JSON sequence file written by Export-MouseSequence, to play back instead of -Steps.

    .PARAMETER Repeat
    How many times to run the whole sequence. Ignored if -DurationSeconds is set. Defaults to 1.

    .PARAMETER DurationSeconds
    Loop the sequence until this many seconds have elapsed, instead of a fixed -Repeat count.
    Checked between laps rather than mid-sequence, so a run can finish a little past the
    requested duration instead of being cut off mid-step (e.g. mid-drag). Takes priority over
    -Repeat when set.

    .EXAMPLE
    PS> $sequence | Invoke-MouseSequence
    Plays the sequence once.

    .EXAMPLE
    PS> $sequence | Invoke-MouseSequence -Repeat 3
    Plays the sequence three times in a row.

    .EXAMPLE
    PS> $sequence | Invoke-MouseSequence -DurationSeconds 300
    Loops the sequence for roughly 5 minutes.

    .EXAMPLE
    PS> Invoke-MouseSequence -Path ./recorded.json
    Loads and plays back a sequence saved earlier with Export-MouseSequence.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Steps')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Steps')]
        [psobject[]]$Steps,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string]$Path,

        [int]$Repeat = 1,

        # Loop the sequence until this many seconds have elapsed instead of a fixed -Repeat count.
        # Checked between laps rather than mid-sequence, so a run can finish a little past the
        # requested duration instead of being cut off mid-step (e.g. mid-drag). Takes priority
        # over -Repeat when set.
        [int]$DurationSeconds = 0
    )

    Begin {
        $collected = @()
    }
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Steps') {
            $collected += $Steps
        }
    }
    End {
        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $collected = @(Import-MouseSequence -Path $Path)
        }

        if ($collected.Count -eq 0) {
            Write-Warning 'Invoke-MouseSequence received no steps to run.'
            return
        }

        if ($DurationSeconds -gt 0) {
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
            do {
                foreach ($step in $collected) {
                    Invoke-MouseStep -Step $step
                }
            } while ($stopwatch.Elapsed.TotalSeconds -lt $DurationSeconds)
        }
        else {
            for ($run = 1; $run -le $Repeat; $run++) {
                foreach ($step in $collected) {
                    Invoke-MouseStep -Step $step
                }
            }
        }
    }
}
