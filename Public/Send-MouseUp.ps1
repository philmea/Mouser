function Send-MouseUp {
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
