function Send-Click {
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [ValidateSet('Left', 'Right', 'Middle')]
        [string]$Button = 'Left',
        [int]$clicks = 1,
        $stationary = $false
    )
    Process {
        if (($null -eq $X) -xor ($null -eq $Y)) {
            throw 'Specify both -X and -Y together, or neither.'
        }
        if ($null -ne $X -and $null -ne $Y) {
            Move-Cursor -X $X -Y $Y | Out-Null
        }

        $click = 1
        $pos = Get-Cursor

        while ($click -le $clicks) {
            if ($stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.x -ne $pos.x -and $currentPos.y -ne $pos.y) {
                    break
                }
            }

            Send-MouseDown -Button $Button
            Send-MouseUp -Button $Button
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
