function Send-Scroll {
    <#
    .SYNOPSIS
    Sends a vertical mouse wheel event.

    .DESCRIPTION
    Scrolls the mouse wheel vertically at the current cursor position via MOUSEEVENTF_WHEEL.

    .PARAMETER Amount
    Wheel delta, in multiples of 120 (WHEEL_DELTA, one notch). Positive scrolls up/forward,
    negative scrolls down/backward. Defaults to 120 (one notch up).

    .EXAMPLE
    PS> Send-Scroll -Amount 120
    Scrolls up one notch.

    .EXAMPLE
    PS> Send-Scroll -Amount -240
    Scrolls down two notches.
    #>
    [CmdletBinding()]
    param (
        # WHEEL_DELTA is 120 and represents one notch. Positive scrolls up/forward, negative scrolls down/backward.
        [int]$Amount = 120
    )
    Process {
        Invoke-Win32MouseEvent -Flags 0x00000800 -Data $Amount # MOUSEEVENTF_WHEEL
    }
}
