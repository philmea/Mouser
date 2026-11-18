function Export-MouseSequence {
    <#
    .SYNOPSIS
    Saves a sequence of mouse steps to a JSON file.

    .DESCRIPTION
    Writes a step array to disk as a { Version, ExportedAt, StepCount, Steps } envelope, so the
    on-disk shape is stable regardless of how many steps it holds (a bare array would serialize a
    single step as {...} instead of [{...}]). Load it back with Import-MouseSequence, or play it
    back directly with Invoke-MouseSequence -Path.

    .PARAMETER Steps
    The steps to save, typically piped in from New-MouseStep or Start-MouseCapture.

    .PARAMETER Path
    File path to write the JSON sequence to.

    .EXAMPLE
    PS> $sequence | Export-MouseSequence -Path ./open-menu.json
    Saved 2 step(s) to ./open-menu.json.
    #>
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
