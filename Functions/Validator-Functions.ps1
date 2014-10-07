function Validate-File([string] $file) {
    if (-not $(Test-Path $file)) {
        Write-Error "ERROR: '$file' does not exist"
        return $false
    }

    $lines_in_file = Get-Content $file

    if (Detect-Tab $lines_in_file -gt 0) {
        Write-Error "ERROR in '$file'`nTAB detected on line $line_tab_detected"
        return $false
    }

    return $true
}

function Detect-Tab($lines) {
    for($i = 0; $i -lt $lines.count; $i++) {
        [string] $line = $lines[$i]
        if ($line.Contains("`t")) {
            return ($i + 1) 
        }
    }

    return 0
}
