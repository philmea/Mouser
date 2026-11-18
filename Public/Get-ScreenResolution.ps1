function Get-ScreenResolution {
    <#
    .SYNOPSIS
    Gets the virtual desktop bounds across every monitor.

    .DESCRIPTION
    Returns the combined bounds of every monitor (SystemInformation.VirtualScreen) - the same
    bounds Set-Cursor validates coordinates against internally. X/Y can be negative when a
    secondary monitor sits to the left of or above the primary one.

    .EXAMPLE
    PS> Get-ScreenResolution
    X Y Width Height
    - - ----- ------
    0 0 1920  1080

    .OUTPUTS
    PSCustomObject with X, Y, Width, Height properties.
    #>
    [CmdletBinding()]
    param (
    )

    Process {
        Add-Type -AssemblyName System.Windows.Forms
        # VirtualScreen covers every monitor, so X/Y can be negative when a secondary monitor sits
        # to the left of or above the primary one.
        $screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
        [PSCustomObject]@{
            X      = $screen.X
            Y      = $screen.Y
            Width  = $screen.Width
            Height = $screen.Height
        }
    }
}
