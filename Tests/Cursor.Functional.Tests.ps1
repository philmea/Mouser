# These exercise the real System.Windows.Forms calls rather than mocking them, since
# GitHub's windows-latest runners provide a real interactive desktop session (unlike a headless
# Linux CI container) where cursor movement actually works. They're the only tests in this module
# that need that - everything else mocks its way around the Win32 dependency.

BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Cursor movement' -Tag 'Functional' {
    It 'moves the cursor and reads the new position back' {
        Set-Cursor -X 100 -Y 100
        $pos = Get-Cursor

        $pos.X | Should -Be 100
        $pos.Y | Should -Be 100
    }

    It 'rejects coordinates outside the virtual screen and leaves the cursor where it was' {
        Set-Cursor -X 100 -Y 100
        $before = Get-Cursor

        Set-Cursor -X 999999999 -Y 999999999 -ErrorAction SilentlyContinue

        $after = Get-Cursor
        $after.X | Should -Be $before.X
        $after.Y | Should -Be $before.Y
    }

    It 'Get-ScreenResolution returns plausible bounds' {
        $resolution = Get-ScreenResolution

        $resolution.Width | Should -BeGreaterThan 0
        $resolution.Height | Should -BeGreaterThan 0
    }
}
