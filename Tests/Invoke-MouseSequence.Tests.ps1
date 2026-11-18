BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Invoke-MouseSequence' {
    BeforeEach {
        Mock -ModuleName 'Mouser' -CommandName Invoke-MouseStep {}
    }

    It 'invokes each piped step once by default' {
        $steps = @(
            (New-MouseStep -Action Click)
            (New-MouseStep -Action Wait)
        )

        $steps | Invoke-MouseSequence

        Should -Invoke -ModuleName 'Mouser' -CommandName Invoke-MouseStep -Times 2
    }

    It 'repeats the whole sequence -Repeat times' {
        $steps = @(New-MouseStep -Action Click)

        $steps | Invoke-MouseSequence -Repeat 3

        Should -Invoke -ModuleName 'Mouser' -CommandName Invoke-MouseStep -Times 3
    }

    It 'loops for -DurationSeconds instead of a fixed count, taking priority over -Repeat' {
        $script:callCount = 0
        Mock -ModuleName 'Mouser' -CommandName Invoke-MouseStep { $script:callCount++ }

        $steps = @(New-MouseStep -Action Click)
        $steps | Invoke-MouseSequence -Repeat 1 -DurationSeconds 1

        # Each mocked Invoke-MouseStep call is effectively instantaneous, so looping a one-step
        # sequence for a full second should run it many more times than a single -Repeat lap would.
        $script:callCount | Should -BeGreaterThan 1
    }

    It 'does not invoke any step when given an empty array' {
        @() | Invoke-MouseSequence -WarningAction SilentlyContinue

        Should -Invoke -ModuleName 'Mouser' -CommandName Invoke-MouseStep -Times 0
    }

    It 'loads steps from -Path via Import-MouseSequence' {
        Mock -ModuleName 'Mouser' -CommandName Import-MouseSequence {
            @(
                (New-MouseStep -Action Click)
                (New-MouseStep -Action Wait)
            )
        }

        Invoke-MouseSequence -Path 'TestDrive:\doesnotmatter.json'

        Should -Invoke -ModuleName 'Mouser' -CommandName Import-MouseSequence -Times 1 -ParameterFilter {
            $Path -eq 'TestDrive:\doesnotmatter.json'
        }
        Should -Invoke -ModuleName 'Mouser' -CommandName Invoke-MouseStep -Times 2
    }
}
