function Load-YamlDotNetLibraries([string] $dllPath, $shadowPath = "$($env:TEMP)\poweryaml\shadow") {
    Get-ChildItem $dllPath | ForEach-Object {
        $shadow = Shadow-Copy -File $_.FullName -ShadowPath $shadowPath
        Add-Type -Path $_.FullName
    } | Out-Null
}

function Read-TextFile([string] $file) {
    return $(Get-Content $file) -join "`n"
}

function Get-YamlDocumentFromString([string] $yamlString) {
    $stringReader = new-object System.IO.StringReader($yamlString)
    $yamlStream = New-Object YamlDotNet.RepresentationModel.YamlStream
    $yamlStream.Load([System.IO.TextReader] $stringReader)

    $document = $yamlStream.Documents[0]
    return $document
}

function Explode-Node($node) {
    if ($node -ne $null) {
        if ($node.GetType().Name -eq "YamlScalarNode") {
            return Convert-YamlScalarNodeToValue $node
        } elseif ($node.GetType().Name -eq "YamlMappingNode") {
            return Convert-YamlMappingNodeToHash $node
        } elseif ($node.GetType().Name -eq "YamlSequenceNode") {
            return Convert-YamlSequenceNodeToList $node
        }
    }
}

function Convert-YamlScalarNodeToValue($node) {
    return Add-CastingFunctions($node.Value)
}

function Convert-YamlMappingNodeToHash($node) {
    $hash = @{}
    $yamlNodes = $node.Children

    foreach($key in $yamlNodes.Keys) {
        $hash[$key.Value] = Explode-Node $yamlNodes[$key]
    }

    return $hash
}

function Convert-YamlSequenceNodeToList($node) {
    $list = @()
    $yamlNodes = $node.Children

    foreach($yamlNode in $yamlNodes) {
        $list += Explode-Node $yamlNode
    }

    return $list
}

