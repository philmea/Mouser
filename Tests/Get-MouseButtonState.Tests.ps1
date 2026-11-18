BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Get-MouseButtonState' {
    It 'returns $true when the underlying key state reports the button is down' {
        Mock -ModuleName 'Mouser' -CommandName Test-Win32KeyState { $true }

        Get-MouseButtonState -Button Left | Should -BeTrue
    }

    It 'returns $false when the underlying key state reports the button is up' {
        Mock -ModuleName 'Mouser' -CommandName Test-Win32KeyState { $false }

        Get-MouseButtonState -Button Right | Should -BeFalse
    }

    It 'checks the correct virtual-key code for <Button>' -TestCases @(
        @{ Button = 'Left'; ExpectedVirtualKey = 0x01 }
        @{ Button = 'Right'; ExpectedVirtualKey = 0x02 }
        @{ Button = 'Middle'; ExpectedVirtualKey = 0x04 }
    ) {
        param($Button, $ExpectedVirtualKey)

        Mock -ModuleName 'Mouser' -CommandName Test-Win32KeyState { $false }

        Get-MouseButtonState -Button $Button | Out-Null

        Should -Invoke -ModuleName 'Mouser' -CommandName Test-Win32KeyState -Times 1 -ParameterFilter {
            $VirtualKey -eq $ExpectedVirtualKey
        }
    }
}
