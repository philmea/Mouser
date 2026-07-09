function New-MouseStep {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Move', 'Click', 'RightClick', 'MiddleClick', 'DoubleClick', 'MouseDown', 'MouseUp', 'Scroll', 'HorizontalScroll', 'Wait')]
        [string]$Action,

        # Move
        [int]$X = 0,
        [int]$Y = 0,
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
