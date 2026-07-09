function Get-MouseButtonState {
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
