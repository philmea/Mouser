BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'New-MouseStep' {
    It 'defaults X and Y to $null when not given' {
        $step = New-MouseStep -Action Move

        $step.X | Should -BeNullOrEmpty
        $step.Y | Should -BeNullOrEmpty
    }

    It 'carries through explicit values' {
        $step = New-MouseStep -Action Click -X 10 -Y 20 -Clicks 3 -Stationary $true `
            -Button Right -Amount 240 -DelayMilliseconds 150 -DurationMilliseconds 0 -Steps 1

        $step.Action | Should -Be 'Click'
        $step.X | Should -Be 10
        $step.Y | Should -Be 20
        $step.Clicks | Should -Be 3
        $step.Stationary | Should -BeTrue
        $step.Button | Should -Be 'Right'
        $step.Amount | Should -Be 240
        $step.DelayMilliseconds | Should -Be 150
        $step.DurationMilliseconds | Should -Be 0
        $step.Steps | Should -Be 1
    }

    It 'applies sensible defaults for everything but Action' {
        $step = New-MouseStep -Action Wait

        $step.Clicks | Should -Be 1
        $step.Stationary | Should -BeFalse
        $step.Button | Should -Be 'Left'
        $step.Amount | Should -Be 120
        $step.DelayMilliseconds | Should -Be 0
        $step.DurationMilliseconds | Should -Be 300
        $step.Steps | Should -Be 30
    }

    It 'rejects an Action outside the known set' {
        { New-MouseStep -Action Teleport } | Should -Throw
    }

    It 'tags the step with the Mouser.MouseStep type name' {
        $step = New-MouseStep -Action Wait

        $step.PSTypeNames | Should -Contain 'Mouser.MouseStep'
    }
}
