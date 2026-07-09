function Invoke-Win32MouseEvent {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$Flags,
        [int]$Dx = 0,
        [int]$Dy = 0,
        [int]$Data = 0
    )

    Process {
        # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-mouse_event
        if (-not ('W.U32MouseEvent' -as [type])) {
            Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern void mouse_event(int flags, int dx, int dy, int cButtons, int info);' -Name U32MouseEvent -Namespace W
        }

        [W.U32MouseEvent]::mouse_event($Flags, $Dx, $Dy, 0, $Data)
    }
}
