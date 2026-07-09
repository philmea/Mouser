function Get-Cursor {
    [CmdletBinding()]
    Param (
    )

    Process {
        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor?view=windowsdesktop-7.0
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor.position?view=windowsdesktop-7.0
        $x = [System.Windows.Forms.Cursor]::Position.X
        $y = [System.Windows.Forms.Cursor]::Position.Y
        Write-Output @{"x" = $x; "y" = $y }
    }
}
