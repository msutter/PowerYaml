$pwd = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests", "")
. "$pwd\$sut"

Describe "Detect-Tab" {
    It "should return the line number the first TAB character is found on" {
        $lines = @()
        $lines += "valide: yaml"
        $lines += "   `t    "
        $line_number_tab_is_in = 2

        $result = Detect-Tab $lines
        $result | Should Be $line_number_tab_is_in
    }

    It "should return 0 if no TAB character is found in text" {
        $result = Detect-Tab "          "
        $result | Should Be 0
    }
}

Describe "Validate-File" {
    Mock Write-Error { return }

    Context "file does not exist" {
        $result = Validate-File "some non existent file"

        It "should throw if a file does not exist" {
            $result | Should be $false
        }
    }

    Context "file does exist and does not contain a tab" {
        Set-Content "TestDrive:\exists.yml" -value ""
        Mock Detect-Tab { return $false }

        $result = Validate-File "TestDrive:\exists.yml"

        It "should return true for a file that does exist and does not contain a TAB character" {
            $result | Should Be $true
        }

        It "should call Detect-Tab once" {
            Assert-MockCalled Detect-Tab 1
        }
    }

    Context "file does exist and contains a tab" {
        Set-Content "TestDrive:\bad.yml" -value "     `t   "
        Mock Detect-Tab { return $true }

        $result = Validate-File "TestDrive:\bad.yml"

        It "should return false" {
            $result | Should Be $false
        }

        It "should call Write-Error once" {
            Assert-MockCalled Write-Error 1
        }

        It "should call Detect-Tab once" {
            Assert-MockCalled Detect-Tab 1
        }
    }
}
