function Send-HorizontalScroll {
    <#
    .SYNOPSIS
    Sends a horizontal mouse wheel event.

    .DESCRIPTION
    Scrolls the mouse wheel horizontally at the current cursor position via MOUSEEVENTF_HWHEEL.

    .PARAMETER Amount
    Wheel delta, in multiples of 120 (WHEEL_DELTA, one notch). Positive scrolls right, negative
    scrolls left. Defaults to 120 (one notch right).

    .EXAMPLE
    PS> Send-HorizontalScroll -Amount 120
    Scrolls right one notch.
    #>
    [CmdletBinding()]
    param (
        # WHEEL_DELTA is 120 and represents one notch. Positive scrolls right, negative scrolls left.
        [int]$Amount = 120
    )
    Process {
        Invoke-Win32MouseEvent -Flags 0x00001000 -Data $Amount # MOUSEEVENTF_HWHEEL
    }
}
