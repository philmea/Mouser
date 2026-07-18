function Get-PixelColor {
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
