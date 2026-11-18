function Get-Cursor {
    <#
    .SYNOPSIS
    Gets the current cursor position.

    .DESCRIPTION
    Returns the mouse cursor's current screen coordinates as a hashtable with X and Y keys.

    .EXAMPLE
    PS> Get-Cursor
    Name                           Value
    ----                           -----
    Y                              300
    X                              500

    .OUTPUTS
    System.Collections.Hashtable
    #>
    [CmdletBinding()]
    Param (
    )

    Process {
        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor?view=windowsdesktop-7.0
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor.position?view=windowsdesktop-7.0
        $x = [System.Windows.Forms.Cursor]::Position.X
        $y = [System.Windows.Forms.Cursor]::Position.Y
        Write-Output @{"X" = $x; "Y" = $y }
    }
}
