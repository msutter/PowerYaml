$packageName = "poweryaml"
$moduleName = "PowerYaml"

try {
  $installPath = Join-Path $PSHome  "Modules\$modulename"
  $hide = Remove-Item -Recurse -Force $installPath
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" $($_.Exception.Message)
  throw
}
