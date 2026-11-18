function Import-MouseSequence {
    <#
    .SYNOPSIS
    Loads a sequence of mouse steps from a JSON file.

    .DESCRIPTION
    Reads a { Version, ExportedAt, StepCount, Steps } envelope written by Export-MouseSequence and
    returns its Steps as an array, ready to pipe into Invoke-MouseSequence. Invoke-MouseSequence
    calls this internally when given -Path, so it's usually not necessary to call this directly
    unless you want the steps themselves (e.g. to inspect or modify them before replaying).

    .PARAMETER Path
    File path to a JSON sequence file written by Export-MouseSequence.

    .EXAMPLE
    PS> Import-MouseSequence -Path ./open-menu.json
    Returns the saved steps as an array of step objects.
    #>
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
