function Get-ScreenResolution {
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
