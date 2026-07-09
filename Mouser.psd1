@{
    RootModule        = 'Mouser.psm1'
    ModuleVersion     = '0.2.0'
    GUID              = '7323ae17-a37d-4fff-9d8b-5aacb26802ce'
    Author            = 'philmea'
    CompanyName       = 'Unknown'
    Copyright         = ''
    Description       = 'Windows mouse automation cmdlets (move, read position, click) built on System.Windows.Forms and user32.dll.'
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    FunctionsToExport = @(
        'Get-Cursor',
        'Set-Cursor',
        'Send-Click',
        'Send-RightClick',
        'Send-MiddleClick',
        'Send-DoubleClick',
        'Send-MouseDown',
        'Send-MouseUp',
        'Send-Scroll',
        'Send-HorizontalScroll'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    PrivateData       = @{
        PSData = @{
            Tags       = @('Mouse', 'Automation', 'Windows', 'UI')
            ProjectUri = 'https://github.com/philmea/mouser'
        }
    }
}
