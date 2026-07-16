function Get-MouseButtonFlags {
    [CmdletBinding()]
    param (
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left'
    )

    # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
    # https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
    switch ($Button) {
        'Left' { @{ Down = 0x00000002; Up = 0x00000004; VirtualKey = 0x01 } } # MOUSEEVENTF_LEFTDOWN / LEFTUP, VK_LBUTTON
        'Right' { @{ Down = 0x00000008; Up = 0x00000010; VirtualKey = 0x02 } } # MOUSEEVENTF_RIGHTDOWN / RIGHTUP, VK_RBUTTON
        'Middle' { @{ Down = 0x00000020; Up = 0x00000040; VirtualKey = 0x04 } } # MOUSEEVENTF_MIDDLEDOWN / MIDDLEUP, VK_MBUTTON
    }
}
