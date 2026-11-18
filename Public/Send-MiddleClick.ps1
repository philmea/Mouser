function Send-MiddleClick {
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [int]$Clicks = 1,
        [bool]$Stationary = $false
    )
    Process {
        Send-Click -X $X -Y $Y -Button Middle -Clicks $Clicks -Stationary $Stationary
    }
}
