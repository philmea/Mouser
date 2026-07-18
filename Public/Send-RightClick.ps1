function Send-RightClick {
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [int]$clicks = 1,
        $stationary = $false
    )
    Process {
        Send-Click -X $X -Y $Y -Button Right -clicks $clicks -stationary $stationary
    }
}
