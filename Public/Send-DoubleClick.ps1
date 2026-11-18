function Send-DoubleClick {
    <#
    .SYNOPSIS
    Sends one or more left double-clicks.

    .DESCRIPTION
    Sends two rapid left clicks, timed using the OS double-click interval
    (SystemInformation.DoubleClickTime) so Windows registers them as an actual double-click
    rather than two separate single clicks.

    .PARAMETER X
    Horizontal coordinate to double-click at. Must be given together with -Y, or omitted entirely
    to double-click at the current cursor position.

    .PARAMETER Y
    Vertical coordinate to double-click at. Must be given together with -X, or omitted entirely to
    double-click at the current cursor position.

    .PARAMETER Clicks
    How many double-clicks to send in a row. Defaults to 1.

    .PARAMETER Stationary
    If $true, stops double-clicking as soon as the cursor is seen to move away from its starting
    position, instead of completing the requested -Clicks count.

    .EXAMPLE
    PS> Send-DoubleClick -X 812 -Y 340
    Moves to (812, 340) and double-clicks there.
    #>
    [CmdletBinding()]
    param (
        [Nullable[int]]$X = $null,
        [Nullable[int]]$Y = $null,
        [int]$Clicks = 1,
        [bool]$Stationary = $false
    )
    Process {
        if (($null -eq $X) -xor ($null -eq $Y)) {
            throw 'Specify both -X and -Y together, or neither.'
        }
        if ($null -ne $X -and $null -ne $Y) {
            Move-Cursor -X $X -Y $Y | Out-Null
        }

        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation.doubleclicktime
        # DoubleClickTime is the max gap (ms) Windows allows between the two clicks of a double-click.
        $interval = [Math]::Max(1, [int]([System.Windows.Forms.SystemInformation]::DoubleClickTime / 3))

        $click = 1
        $pos = Get-Cursor

        while ($click -le $Clicks) {
            if ($Stationary -eq $true) {
                $currentPos = Get-Cursor
                if ($currentPos.X -ne $pos.X -and $currentPos.Y -ne $pos.Y) {
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
