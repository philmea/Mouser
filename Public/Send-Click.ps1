function Send-Click {
    [CmdletBinding()]
    param (
        [int]$clicks = 1,
        $stationary = $false
    )
    Process {
        Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32SendClick -Namespace W;
        # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
        $click = 1
        $pos = Get-Cursor

        while ($click -le $clicks) {
            if ($stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.x -ne $pos.x -and $currentPos.y -ne $pos.y) {
                    break
                }
            }

            [W.U32SendClick]::mouse_event(0x00000002, 0, 0, 0, 0);
            [W.U32SendClick]::mouse_event(0x00000004, 0, 0, 0, 0);
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
