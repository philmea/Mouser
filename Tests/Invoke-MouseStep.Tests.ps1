BeforeAll {
    Import-Module "$PSScriptRoot/../Mouser.psd1" -Force
}

Describe 'Invoke-MouseStep' {
    BeforeEach {
        Mock -ModuleName 'Mouser' -CommandName Move-Cursor {}
        Mock -ModuleName 'Mouser' -CommandName Send-Click {}
        Mock -ModuleName 'Mouser' -CommandName Send-RightClick {}
        Mock -ModuleName 'Mouser' -CommandName Send-MiddleClick {}
        Mock -ModuleName 'Mouser' -CommandName Send-DoubleClick {}
        Mock -ModuleName 'Mouser' -CommandName Send-MouseDown {}
        Mock -ModuleName 'Mouser' -CommandName Send-MouseUp {}
        Mock -ModuleName 'Mouser' -CommandName Send-Scroll {}
        Mock -ModuleName 'Mouser' -CommandName Send-HorizontalScroll {}
        Mock -ModuleName 'Mouser' -CommandName Start-Sleep {}
    }

    It 'dispatches a Move step to Move-Cursor with X/Y/duration/steps' {
        $step = New-MouseStep -Action Move -X 10 -Y 20 -DurationMilliseconds 50 -Steps 5

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Move-Cursor -Times 1 -ParameterFilter {
            $X -eq 10 -and $Y -eq 20 -and $DurationMilliseconds -eq 50 -and $Steps -eq 5
        }
    }

    It 'dispatches a Click step to Send-Click with X/Y/Clicks/Stationary' {
        $step = New-MouseStep -Action Click -X 1 -Y 2 -Clicks 3 -Stationary $true

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-Click -Times 1 -ParameterFilter {
            $X -eq 1 -and $Y -eq 2 -and $Clicks -eq 3 -and $Stationary -eq $true
        }
    }

    It 'dispatches a RightClick step to Send-RightClick' {
        $step = New-MouseStep -Action RightClick

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-RightClick -Times 1
    }

    It 'dispatches a MiddleClick step to Send-MiddleClick' {
        $step = New-MouseStep -Action MiddleClick

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-MiddleClick -Times 1
    }

    It 'dispatches a DoubleClick step to Send-DoubleClick' {
        $step = New-MouseStep -Action DoubleClick

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-DoubleClick -Times 1
    }

    It 'dispatches a MouseDown step to Send-MouseDown with the right button' {
        $step = New-MouseStep -Action MouseDown -Button Right

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-MouseDown -Times 1 -ParameterFilter { $Button -eq 'Right' }
    }

    It 'dispatches a MouseUp step to Send-MouseUp with the right button' {
        $step = New-MouseStep -Action MouseUp -Button Middle

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-MouseUp -Times 1 -ParameterFilter { $Button -eq 'Middle' }
    }

    It 'dispatches a Scroll step to Send-Scroll with the right amount' {
        $step = New-MouseStep -Action Scroll -Amount -240

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-Scroll -Times 1 -ParameterFilter { $Amount -eq -240 }
    }

    It 'dispatches a HorizontalScroll step to Send-HorizontalScroll with the right amount' {
        $step = New-MouseStep -Action HorizontalScroll -Amount 360

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Send-HorizontalScroll -Times 1 -ParameterFilter { $Amount -eq 360 }
    }

    It 'sleeps for DelayMilliseconds after a step when greater than zero' {
        $step = New-MouseStep -Action Click -DelayMilliseconds 100

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Start-Sleep -Times 1 -ParameterFilter { $Milliseconds -eq 100 }
    }

    It 'does not sleep when DelayMilliseconds is zero' {
        $step = New-MouseStep -Action Wait -DelayMilliseconds 0

        InModuleScope 'Mouser' -Parameters @{ Step = $step } { param($Step) Invoke-MouseStep -Step $Step }

        Should -Invoke -ModuleName 'Mouser' -CommandName Start-Sleep -Times 0
    }
}
