function Send-RightClick {
    <#
    .SYNOPSIS
    Sends one or more right mouse clicks.

    .DESCRIPTION
    Shorthand for Send-Click -Button Right. See Get-Help Send-Click for full parameter details.

    .PARAMETER X
    Horizontal coordinate to click at. Must be given together with -Y, or omitted entirely to
    click at the current cursor position.

    .PARAMETER Y
    Vertical coordinate to click at. Must be given together with -X, or omitted entirely to click
    at the current cursor position.

    .PARAMETER Clicks
    How many times to click in a row, each separated by a short pause. Defaults to 1.

    .PARAMETER Stationary
    If $true, stops clicking as soon as the cursor is seen to move away from its starting
    position, instead of completing the requested -Clicks count.

    .EXAMPLE
    PS> Send-RightClick -X 812 -Y 340
    Moves to (812, 340) and right-clicks there.
    #>
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [int]$Clicks = 1,
        [bool]$Stationary = $false
    )
    Process {
        Send-Click -X $X -Y $Y -Button Right -Clicks $Clicks -Stationary $Stationary
    }
}
