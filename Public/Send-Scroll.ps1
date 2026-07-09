function Send-Scroll {
    [CmdletBinding()]
    param (
        # WHEEL_DELTA is 120 and represents one notch. Positive scrolls up/forward, negative scrolls down/backward.
        [int]$Amount = 120
    )
    Process {
        Invoke-Win32MouseEvent -Flags 0x00000800 -Data $Amount # MOUSEEVENTF_WHEEL
    }
}
