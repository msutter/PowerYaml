$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module $here\PowerYaml.psm1 -Force

Describe "Get-Yaml" {
    Mock Write-Error { return }

    Context "FromString supplied and no FromFile supplied" {
        It "Obtains a HashTable given a yaml hash" {
            $yaml = Get-Yaml -FromString "key: value"
            $yaml.GetType().Name | Should Be "HashTable"
        }

        It "Obtains an Object[] given a yaml array" {
            $yaml = Get-Yaml -FromString "- test`n- test2"
            $yaml.GetType().Name | Should Be "Object[]"
        }
    }

    Context "no FromString supplied but FromFile supplied" {
        Set-Content "TestDrive:\sample.yml" -value "test: value"

        $yaml = Get-Yaml -FromFile "TestDrive:\sample.yml"

        It "Can read the file and get the value" {
            $yaml.test | Should Be "value"
        }
    }

    Context "both FromString and FromFile supplied" {
        It "thows exception" {
            { Get-Yaml -FromString "key: value" -FromFile "TestDrive:\sample.yml" } | Should throw
        }
    }

    Context "neither FromString or FromFile supplied" {
        It "throws exception" {
            { Get-Yaml } | Should throw
        }
    }
}

Remove-Module PowerYaml
