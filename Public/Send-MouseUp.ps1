function Send-MouseUp {
    <#
    .SYNOPSIS
    Releases a previously pressed mouse button.

    .DESCRIPTION
    Sends a button-up event, completing a press started with Send-MouseDown.

    .PARAMETER Button
    Which mouse button to release. One of Left, Right, Middle. Defaults to Left.

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
        Invoke-Win32MouseEvent -Flags $flags.Up
    }
}
