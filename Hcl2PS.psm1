$Script:Hcl2JsonVersion = '0.5.0'

foreach ($directory in @('Public', 'Private')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}

$Script:executableName = if ($IsWindows) {
    "hcl2json_windows_amd64.exe"
} elseif ($IsLinux) {
    if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
        "hcl2json_linux_amd64"
    }
    if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
        "hcl2json_linux_arm64"
    } else{
        "hcl2json_linux_amd64"
    }
} elseif ($IsMacOS) {
    if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
        "hcl2json_darwin_amd64"
    }
    if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
        "hcl2json_darwin_arm64"
    } else{
        "hcl2json_darwin_amd64"
    }
} else{
    Write-Error "Operating System and or Process Architecture Unkown or Unsupported" -ErrorAction Stop
}

$Script:cliPath = Join-Path $PSScriptRoot 'bin' $Hcl2JsonVersion $executableName


if((test-path $cliPath) -ne $true){
    Write-Error "Problem with the CLI Executable" -ErrorAction Stop
} elseif($IsLinux -or $IsMacOS){
    & chmod +x $cliPath
}