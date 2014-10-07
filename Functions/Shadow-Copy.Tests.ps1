$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe "Shadow-Copy" {
    Mock Write-Debug { return }

    Set-Content "TestDrive:\testfile" -Value ""
    $isolatedShadowPath = Join-Path $env:TEMP "poweryaml\tests\shadow"

    Context "there is no existing file or shadow directory" {
        if (Test-Path $isolatedShadowPath) {
            Remove-Item $isolatedShadowPath -Force -Recurse
        }

        $result = Shadow-Copy -File "TestDrive:\testfile" -ShadowPath $isolatedShadowPath

        It "copies a file to a transient location" {
            Join-Path $isolatedShadowPath "testfile" | Should Exist
        }

        It "returns a path to the shadow copied file" {
            $result | Should Be "$isolatedShadowPath\testfile"
        }
    }

    Context "there is an existing file and it is open" {
        $shadow_file_path = Join-Path $isolatedShadowPath "testfile"
        $file = [System.IO.File]::Open($shadow_file_path, 'Open', 'Read', 'None')
        $shadow = Shadow-Copy -File "TestDrive:\testfile" -ShadowPath $isolatedShadowPath
        $file.Close()

        It "debug message written" {
            Assert-MockCalled Write-Debug 1
        }

    }
}
