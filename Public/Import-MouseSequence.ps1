function Import-MouseSequence {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Path
    )

    Process {
        $sequence = Get-Content -Path $Path -Raw | ConvertFrom-Json

        if ($null -eq $sequence.Steps) {
            throw "'$Path' does not look like a Mouser sequence file (missing a 'Steps' property)."
        }

        # ConvertFrom-Json still collapses a single-element JSON array back into a scalar object,
        # regardless of how it was written, so this needs its own array wrap on the way back out.
        @($sequence.Steps)
    }
}
