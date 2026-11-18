function New-MouseStep {
    <#
    .SYNOPSIS
    Builds a single mouse step for use with Invoke-MouseSequence.

    .DESCRIPTION
    Creates one step object describing a single action - a move, a click, a button press/release,
    a scroll, or a plain wait. A series of steps built with this cmdlet can be piped into
    Invoke-MouseSequence to play them back in order, or saved to disk with Export-MouseSequence
    for later replay.

    -X/-Y apply to the Move action and to the click actions (Click, RightClick, MiddleClick,
    DoubleClick). On a click action, giving -X/-Y moves there first (interpolated, same as a
    standalone Move step) and then clicks - one step instead of a separate Move + Click pair for
    what's really one action. Omit -X/-Y on a click action to click at whatever position the
    sequence is already at.

    .PARAMETER Action
    The action this step performs: Move, Click, RightClick, MiddleClick, DoubleClick, MouseDown,
    MouseUp, Scroll, HorizontalScroll, or Wait.

    .PARAMETER X
    Horizontal target coordinate. Required for Move; optional for the click actions (moves there
    first when given, together with -Y).

    .PARAMETER Y
    Vertical target coordinate. Required for Move; optional for the click actions (moves there
    first when given, together with -X).

    .PARAMETER DurationMilliseconds
    For Move and the click actions' move-first behavior: total time to spend moving there. 0
    jumps straight to the target. Defaults to 300.

    .PARAMETER Steps
    For Move and the click actions' move-first behavior: number of intermediate positions to send
    along the way. Defaults to 30.

    .PARAMETER Clicks
    For the click actions: how many times to click in a row. Defaults to 1.

    .PARAMETER Stationary
    For the click actions: if $true, stops clicking as soon as the cursor moves away from its
    starting position.

    .PARAMETER Button
    For MouseDown/MouseUp: which button to press or release. One of Left, Right, Middle. Defaults
    to Left.

    .PARAMETER Amount
    For Scroll/HorizontalScroll: wheel delta, in multiples of 120 (one notch). Defaults to 120.

    .PARAMETER DelayMilliseconds
    Pause applied after this step runs, before the next one starts. Applies to every action,
    including Wait. Defaults to 0.

    .EXAMPLE
    PS> New-MouseStep -Action Click -X 100 -Y 40 -DelayMilliseconds 150
    Moves to (100, 40), clicks, then pauses 150ms before the next step runs.

    .EXAMPLE
    PS> @(
    >>     New-MouseStep -Action Click -X 100 -Y 40 -DelayMilliseconds 150
    >>     New-MouseStep -Action Click -X 100 -Y 90
    >> ) | Invoke-MouseSequence
    Builds a two-step sequence and plays it back immediately.

    .OUTPUTS
    PSCustomObject (Mouser.MouseStep)
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Move', 'Click', 'RightClick', 'MiddleClick', 'DoubleClick', 'MouseDown', 'MouseUp', 'Scroll', 'HorizontalScroll', 'Wait')]
        [string]$Action,

        # Move, and optionally Click / RightClick / MiddleClick / DoubleClick (moves there first)
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [int]$DurationMilliseconds = 300,
        [int]$Steps = 30,

        # Click / RightClick / MiddleClick / DoubleClick
        [int]$Clicks = 1,
        [bool]$Stationary = $false,

        # MouseDown / MouseUp
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left',

        # Scroll / HorizontalScroll
        [int]$Amount = 120,

        # Pause applied after this step runs, in every Action (including Wait)
        [int]$DelayMilliseconds = 0
    )

    Process {
        [PSCustomObject]@{
            PSTypeName           = 'Mouser.MouseStep'
            Action               = $Action
            X                    = $X
            Y                    = $Y
            DurationMilliseconds = $DurationMilliseconds
            Steps                = $Steps
            Clicks               = $Clicks
            Stationary           = $Stationary
            Button               = $Button
            Amount               = $Amount
            DelayMilliseconds    = $DelayMilliseconds
        }
    }
}
