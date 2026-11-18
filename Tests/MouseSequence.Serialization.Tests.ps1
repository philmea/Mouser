BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Export-MouseSequence and Import-MouseSequence' {
    It 'round-trips a single step (the historical single-element-JSON-array gotcha)' {
        $path = Join-Path $TestDrive 'single-step.json'
        @(New-MouseStep -Action Click -X 5 -Y 6) | Export-MouseSequence -Path $path

        $roundTripped = @(Import-MouseSequence -Path $path)

        $roundTripped.Count | Should -Be 1
        $roundTripped[0].Action | Should -Be 'Click'
        $roundTripped[0].X | Should -Be 5
        $roundTripped[0].Y | Should -Be 6
    }

    It 'round-trips multiple steps' {
        $path = Join-Path $TestDrive 'multi-step.json'
        @(
            (New-MouseStep -Action Move -X 1 -Y 2)
            (New-MouseStep -Action Click -X 1 -Y 2)
            (New-MouseStep -Action Wait -DelayMilliseconds 100)
        ) | Export-MouseSequence -Path $path

        $roundTripped = @(Import-MouseSequence -Path $path)

        $roundTripped.Count | Should -Be 3
        $roundTripped[0].Action | Should -Be 'Move'
        $roundTripped[2].DelayMilliseconds | Should -Be 100
    }

    It 'writes a stable { Version, ExportedAt, StepCount, Steps } envelope' {
        $path = Join-Path $TestDrive 'envelope.json'
        @(New-MouseStep -Action Wait) | Export-MouseSequence -Path $path

        $json = Get-Content -Path $path -Raw | ConvertFrom-Json

        $json.Version | Should -Be 1
        $json.StepCount | Should -Be 1
        $json.ExportedAt | Should -Not -BeNullOrEmpty
        $json.Steps | Should -Not -BeNullOrEmpty
    }

    It 'throws a clear error for a file missing a Steps property' {
        $path = Join-Path $TestDrive 'not-a-sequence.json'
        '{"hello":"world"}' | Set-Content -Path $path

        { Import-MouseSequence -Path $path } | Should -Throw '*does not look like a Mouser sequence file*'
    }
}
