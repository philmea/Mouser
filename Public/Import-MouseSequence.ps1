function Import-MouseSequence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    Process {
        # ConvertFrom-Json returns a single object instead of an array when the file has one step.
        @(Get-Content -Path $Path -Raw | ConvertFrom-Json)
    }
}
