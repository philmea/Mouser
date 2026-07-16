function Export-MouseSequence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [psobject[]]$Steps,

        [Parameter(Mandatory)]
        [string]$Path
    )

    Begin {
        $collected = @()
    }
    Process {
        $collected += $Steps
    }
    End {
        # Wrapping Steps in an envelope keeps the on-disk shape stable regardless of step count -
        # piping a bare array straight into ConvertTo-Json collapses a single-element array down to
        # one JSON object instead of a one-element JSON array, so consumers would see two different
        # top-level shapes depending on how many steps were captured.
        $sequence = [PSCustomObject]@{
            Version    = 1
            ExportedAt = (Get-Date).ToUniversalTime().ToString('o')
            StepCount  = $collected.Count
            Steps      = $collected
        }

        $sequence | ConvertTo-Json -Depth 6 | Set-Content -Path $Path -Encoding utf8
        Write-Output "Saved $($collected.Count) step(s) to $Path."
    }
}
