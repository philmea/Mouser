function Get-PixelColor {
    <#
    .SYNOPSIS
    Gets the color of a pixel on screen.

    .DESCRIPTION
    Captures a single pixel at the given screen coordinates and returns its color, for
    verify-before-click checks (e.g. wait until a button visibly lights up or changes state)
    instead of clicking blind.

    .PARAMETER X
    Horizontal coordinate of the pixel, in screen pixels.

    .PARAMETER Y
    Vertical coordinate of the pixel, in screen pixels.

    .EXAMPLE
    PS> Get-PixelColor -X 812 -Y 340
    R   G   B   Hex
    -   -   -   ---
    255 255 255 #FFFFFF

    .OUTPUTS
    PSCustomObject with R, G, B, Hex properties.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$X,
        [Parameter(Mandatory)]
        [int]$Y
    )

    Process {
        Add-Type -AssemblyName System.Drawing
        $bitmap = [System.Drawing.Bitmap]::new(1, 1)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)

        try {
            $graphics.CopyFromScreen($X, $Y, 0, 0, [System.Drawing.Size]::new(1, 1))
            $color = $bitmap.GetPixel(0, 0)

            [PSCustomObject]@{
                R   = $color.R
                G   = $color.G
                B   = $color.B
                Hex = ('#{0:X2}{1:X2}{2:X2}' -f $color.R, $color.G, $color.B)
            }
        }
        finally {
            $graphics.Dispose()
            $bitmap.Dispose()
        }
    }
}
