function Invoke-MouseSequence {
    [CmdletBinding(DefaultParameterSetName = 'Steps')]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'Steps')]
        [psobject[]]$Steps,

        [Parameter(Mandatory, ParameterSetName = 'Path')]
        [string]$Path,

        [int]$Repeat = 1
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

        for ($run = 1; $run -le $Repeat; $run++) {
            foreach ($step in $collected) {
                Write-Verbose "Step $($step.Action): $($step | Out-String)"

                switch ($step.Action) {
                    'Move' { Move-Cursor -X $step.X -Y $step.Y -DurationMilliseconds $step.DurationMilliseconds -Steps $step.Steps | Out-Null }
                    'Click' { Send-Click -clicks $step.Clicks -stationary $step.Stationary }
                    'RightClick' { Send-RightClick -clicks $step.Clicks -stationary $step.Stationary }
                    'MiddleClick' { Send-MiddleClick -clicks $step.Clicks -stationary $step.Stationary }
                    'DoubleClick' { Send-DoubleClick -clicks $step.Clicks -stationary $step.Stationary }
                    'MouseDown' { Send-MouseDown -Button $step.Button }
                    'MouseUp' { Send-MouseUp -Button $step.Button }
                    'Scroll' { Send-Scroll -Amount $step.Amount }
                    'HorizontalScroll' { Send-HorizontalScroll -Amount $step.Amount }
                    'Wait' { }
                    default { Write-Error "Unknown mouse step action: $($step.Action)" }
                }

                if ($step.DelayMilliseconds -gt 0) {
                    Start-Sleep -Milliseconds $step.DelayMilliseconds
                }
            }
        }
    }
}
