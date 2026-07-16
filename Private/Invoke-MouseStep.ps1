function Invoke-MouseStep {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [psobject]$Step
    )

    Process {
        Write-Verbose "Step $($Step.Action): $($Step | Out-String)"

        switch ($Step.Action) {
            'Move' { Move-Cursor -X $Step.X -Y $Step.Y -DurationMilliseconds $Step.DurationMilliseconds -Steps $Step.Steps | Out-Null }
            'Click' { Send-Click -clicks $Step.Clicks -stationary $Step.Stationary }
            'RightClick' { Send-RightClick -clicks $Step.Clicks -stationary $Step.Stationary }
            'MiddleClick' { Send-MiddleClick -clicks $Step.Clicks -stationary $Step.Stationary }
            'DoubleClick' { Send-DoubleClick -clicks $Step.Clicks -stationary $Step.Stationary }
            'MouseDown' { Send-MouseDown -Button $Step.Button }
            'MouseUp' { Send-MouseUp -Button $Step.Button }
            'Scroll' { Send-Scroll -Amount $Step.Amount }
            'HorizontalScroll' { Send-HorizontalScroll -Amount $Step.Amount }
            'Wait' { }
            default { Write-Error "Unknown mouse step action: $($Step.Action)" }
        }

        if ($Step.DelayMilliseconds -gt 0) {
            Start-Sleep -Milliseconds $Step.DelayMilliseconds
        }
    }
}
