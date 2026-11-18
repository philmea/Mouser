function Send-Click {
    <#
    .SYNOPSIS
    Sends one or more mouse clicks.

    .DESCRIPTION
    Clicks a mouse button at the current cursor position, or at a given point if -X/-Y are
    supplied (moving there first, interpolated through Move-Cursor). Send-RightClick and
    Send-MiddleClick are shorthand for this cmdlet with -Button Right/Middle.

    .PARAMETER X
    Horizontal coordinate to click at. Must be given together with -Y, or omitted entirely to
    click at the current cursor position.

    .PARAMETER Y
    Vertical coordinate to click at. Must be given together with -X, or omitted entirely to click
    at the current cursor position.

    .PARAMETER Button
    Which mouse button to click. One of Left, Right, Middle. Defaults to Left.

    .PARAMETER Clicks
    How many times to click in a row, each separated by a short pause. Defaults to 1.

    .PARAMETER Stationary
    If $true, stops clicking as soon as the cursor is seen to move away from its starting
    position, instead of completing the requested -Clicks count.

    .EXAMPLE
    PS> Send-Click
    Left-clicks once at the current cursor position.

    .EXAMPLE
    PS> Send-Click -X 812 -Y 340 -Button Right
    Moves to (812, 340) and right-clicks there.

    .EXAMPLE
    PS> Send-Click -Clicks 3 -Stationary $true
    Clicks up to 3 times, stopping early if the cursor moves between clicks.
    #>
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left',
        [int]$Clicks = 1,
        [bool]$Stationary = $false
    )
    Process {
        if (($null -eq $X) -xor ($null -eq $Y)) {
            throw 'Specify both -X and -Y together, or neither.'
        }
        if ($null -ne $X -and $null -ne $Y) {
            Move-Cursor -X $X -Y $Y | Out-Null
        }

        $click = 1
        $pos = Get-Cursor

        while ($click -le $Clicks) {
            if ($Stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.X -ne $pos.X -and $currentPos.Y -ne $pos.Y) {
                    break
                }
            }

            Send-MouseDown -Button $Button
            Send-MouseUp -Button $Button
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
