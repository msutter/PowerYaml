. $PSScriptRoot\Functions\Casting.ps1
. $PSScriptRoot\Functions\Shadow-Copy.ps1
. $PSScriptRoot\Functions\YamlDotNet-Integration.ps1
. $PSScriptRoot\Functions\Validator-Functions.ps1

<#
    .Synopsis
    Returns an object that can be dot navigated

    .Parameter FromFile
    File reference to a yaml document

    .Parameter FromString
    Yaml string to be converted
#>

function Get-Yaml {
    param (
        [string]
        $FromString = "",

        [string]
        $FromFile = ""
    )

    if ($FromString -eq "" -and $FromFile -ne "") {
        $yamlString = Read-TextFile $FromFile
    }
    elseif ($FromString -ne "" -and $FromFile -eq "") {
        $yamlString = $FromString
    }
    elseif ($FromString -ne "" -and $FromFile -ne "") {
        Throw "Need to specify either FromString or FromFile"
        # return
    }
    else {
        Throw "Need to specify only FromString or FromFile, not both"
        # return
    }

    $yaml = Get-YamlDocumentFromString $yamlString

    return Explode-Node $yaml.RootNode
}

Load-YamlDotNetLibraries (Join-Path $PSScriptRoot -ChildPath "Libs")
Export-ModuleMember -Function Get-Yaml
