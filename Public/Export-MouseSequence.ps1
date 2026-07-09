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
        $collected | ConvertTo-Json -Depth 5 | Set-Content -Path $Path -Encoding utf8
        Write-Output "Saved $($collected.Count) step(s) to $Path."
    }
}
