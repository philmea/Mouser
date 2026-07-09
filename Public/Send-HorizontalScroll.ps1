function Send-HorizontalScroll {
    [CmdletBinding()]
    param (
        # WHEEL_DELTA is 120 and represents one notch. Positive scrolls right, negative scrolls left.
        [int]$Amount = 120
    )
    Process {
        Invoke-Win32MouseEvent -Flags 0x00001000 -Data $Amount # MOUSEEVENTF_HWHEEL
    }
}
