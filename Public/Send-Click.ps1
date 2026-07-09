function Send-Click {
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

            Invoke-Win32MouseEvent -Flags 0x00000002 # MOUSEEVENTF_LEFTDOWN
            Invoke-Win32MouseEvent -Flags 0x00000004 # MOUSEEVENTF_LEFTUP
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
