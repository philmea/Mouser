function Send-MiddleClick {
    [CmdletBinding()]
    param (
        [int]$clicks = 1,
        $stationary = $false
    )
    Process {
        $click = 1
        $pos = Get-Cursor

        while ($click -le $clicks) {
            if ($stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.x -ne $pos.x -and $currentPos.y -ne $pos.y) {
                    break
                }
            }

            Send-MouseDown -Button Middle
            Send-MouseUp -Button Middle
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
