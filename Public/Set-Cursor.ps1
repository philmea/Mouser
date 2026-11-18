function Set-Cursor {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]$X = 0,
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]$Y = 0
    )

    Process {

        Add-Type -AssemblyName System.Windows.Forms
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation?view=windowsdesktop-7.0
        # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.systeminformation.virtualscreen?view=windowsdesktop-7.0
        <#
            The VirtualScreen property indicates the bounds of the entire desktop on a multi-monitor system. You can use this property to determine the maximum visual space available on a system that has multiple monitors installed.
            #>
        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        if ($X -gt $screen.Width) {
            Write-Error -Message "Width coordinate 'X' is greater than the width of your screen."
        }
        elseif ($Y -gt $screen.Height) {
            Write-Error -Message "Height coordinate 'Y' is greater than the height of your screen."
        }
        else {
            # https://learn.microsoft.com/en-us/dotnet/api/system.windows.forms.cursor.position?view=windowsdesktop-7.0
            <#Gets or sets the cursor's position.
                #>
            [System.Windows.Forms.Cursor]::Position = "$($X),$($Y)"
            Write-Output "Cursor moved to x: $X, y: $Y."
        }
    }
}
