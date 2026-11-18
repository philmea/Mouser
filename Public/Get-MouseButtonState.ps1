function Get-MouseButtonState {
    <#
    .SYNOPSIS
    Checks whether a mouse button is currently held down.

    .DESCRIPTION
    Returns whether a mouse button is pressed right now, via GetAsyncKeyState. Used internally
    by Start-MouseCapture to detect button-down/button-up transitions while recording.

    .PARAMETER Button
    Which mouse button to check. One of Left, Right, Middle. Defaults to Left.

    .EXAMPLE
    PS> Get-MouseButtonState -Button Left
    False

    .OUTPUTS
    System.Boolean
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left'
    )

    Process {
        $flags = Get-MouseButtonFlags -Button $Button
        Test-Win32KeyState -VirtualKey $flags.VirtualKey
    }
}
