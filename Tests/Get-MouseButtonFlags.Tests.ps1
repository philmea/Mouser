BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Get-MouseButtonFlags' {
    It 'returns the correct down/up/virtual-key values for <Button>' -TestCases @(
        @{ Button = 'Left'; Down = 0x00000002; Up = 0x00000004; VirtualKey = 0x01 }
        @{ Button = 'Right'; Down = 0x00000008; Up = 0x00000010; VirtualKey = 0x02 }
        @{ Button = 'Middle'; Down = 0x00000020; Up = 0x00000040; VirtualKey = 0x04 }
    ) {
        param($Button, $Down, $Up, $VirtualKey)

        $flags = InModuleScope 'Mouser' -Parameters @{ Button = $Button } {
            param($Button)
            Get-MouseButtonFlags -Button $Button
        }

        $flags.Down | Should -Be $Down
        $flags.Up | Should -Be $Up
        $flags.VirtualKey | Should -Be $VirtualKey
    }
}
