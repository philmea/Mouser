function Send-MouseDown {
    <#
    .SYNOPSIS
    Presses and holds a mouse button.

    .DESCRIPTION
    Sends a button-down event without releasing it, for building drags or press-and-hold
    interactions. Pair with Send-MouseUp to release the button afterward.

    .PARAMETER Button
    Which mouse button to press. One of Left, Right, Middle. Defaults to Left.

    .EXAMPLE
    PS> Send-MouseDown -Button Left
    PS> Set-Cursor -X 800 -Y 400
    PS> Send-MouseUp -Button Left
    Presses the left button, drags the cursor to (800, 400), then releases it.
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left'
    )

    Process {
        $flags = Get-MouseButtonFlags -Button $Button
        Invoke-Win32MouseEvent -Flags $flags.Down
    }
}
