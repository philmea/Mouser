function Get-MouseButtonFlags {
    [CmdletBinding()]
    param (
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left'
    )

    # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
    switch ($Button) {
        'Left' { @{ Down = 0x00000002; Up = 0x00000004 } } # MOUSEEVENTF_LEFTDOWN / LEFTUP
        'Right' { @{ Down = 0x00000008; Up = 0x00000010 } } # MOUSEEVENTF_RIGHTDOWN / RIGHTUP
        'Middle' { @{ Down = 0x00000020; Up = 0x00000040 } } # MOUSEEVENTF_MIDDLEDOWN / MIDDLEUP
    }
}
