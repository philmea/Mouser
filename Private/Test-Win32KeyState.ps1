function Test-Win32KeyState {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [int]$VirtualKey
    )

    Process {
        # https://learn.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getasynckeystate
        if (-not ('W.U32KeyState' -as [type])) {
            Add-Type -MemberDefinition '[DllImport("user32.dll")] public static extern short GetAsyncKeyState(int vKey);' -Name U32KeyState -Namespace W
        }

        ([W.U32KeyState]::GetAsyncKeyState($VirtualKey) -band 0x8000) -ne 0
    }
}
