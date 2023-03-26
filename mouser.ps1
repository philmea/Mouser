
function Get-Cursor {
    [CmdletBinding()]
    Param (   
    )
    
    Process{
        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor?view=windowsdesktop-7.0
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor.position?view=windowsdesktop-7.0
        $x = [System.Windows.Forms.Cursor]::Position.X
        $y = [System.Windows.Forms.Cursor]::Position.Y
        Write-Output @{"x"=$x;"y"=$y}
    }
}

Function Set-Cursor {
    [CmdletBinding()]
    Param (
            [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
            [int]$x = 0, 
            [Parameter(ValueFromPipeline,ValueFromPipelineByPropertyName)]
            [int]$y = 0,
            [hashtable]$posHash
    
        )
    
    Process {
    
            Add-Type -AssemblyName System.Windows.Forms
            # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation?view=windowsdesktop-7.0
            # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation.virtualscreen?view=windowsdesktop-7.0
            <#
            The VirtualScreen property indicates the bounds of the entire desktop on a multi-monitor system. You can use this property to determine the maximum visual space available on a system that has multiple monitors installed.
            #>
            $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
            if ($x -gt $screen.Width){
                Write-Error -Message "Width coordinate 'x' is greater than the width of your screen."
            }
            elseif ($y -gt $screen.Height) {
                Write-Error -Message "Height coordinate 'y' is greater than the height of your screen."
            }
            else{
                # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor.position?view=windowsdesktop-7.0
                <#Gets or sets the cursor's position.
                #>
                [System.Windows.Forms.Cursor]::Position = "$($x),$($y)"
                Write-Output "Cursor moved to x: $x, y: $y."
            }
        }
    }

function Send-Click{
    [CmdletBinding()]
    param (
        [int]$clicks = 1,
        $stationary = $false
    )
Process{
    Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32SendClick -Namespace W;
    # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
    $click = 1
    $pos = Get-Cursor

    while ($click -le $clicks){
        if ($stationary -eq $true){
            $currentPos = Get-Cursor
            if($currentPos.x -ne $pos.x -and $currentPos.y -ne $pos.y){
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

