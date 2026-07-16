function Invoke-MouseSequence {
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
