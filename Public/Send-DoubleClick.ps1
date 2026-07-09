function Send-DoubleClick {
    [CmdletBinding()]
    param (
        [int]$clicks = 1,
        $stationary = $false
    )
    Process {
        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation.doubleclicktime
        # DoubleClickTime is the max gap (ms) Windows allows between the two clicks of a double-click.
        $interval = [Math]::Max(1, [int]([System.Windows.Forms.SystemInformation]::DoubleClickTime / 3))

        $click = 1
        $pos = Get-Cursor

        while ($click -le $clicks) {
            if ($stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.x -ne $pos.x -and $currentPos.y -ne $pos.y) {
                    break
                }
            }

            Send-MouseDown -Button Left
            Send-MouseUp -Button Left
            Start-Sleep -Milliseconds $interval
            Send-MouseDown -Button Left
            Send-MouseUp -Button Left
            Start-Sleep -Milliseconds 50
            $click++
        }
    }
}
