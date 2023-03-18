function ConvertFrom-Hcl {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(ParameterSetName = 'Path', Mandatory = $true)]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InputObject
    )
    
    # Use the appropriate parameter set based on whether Path or Pipeline input is provided
    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $HclContent = Get-Content $Path -Raw
    }
    else {
        $HclContent = $InputObject
    }
 
    $executableName = if ($IsWindows) {
        "hcl2json_windows_amd64.exe"
    } elseif ($IsLinux) {
        if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
            "hcl2json_linux_amd64"
        }
        if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
            "hcl2json_linux_arm64"
        }
    } elseif ($IsMacOS) {
        if ($env:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
            "hcl2json_darwin_amd64"
        }
        if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') {
            "hcl2json_darwin_arm64"
        }
    } else{
        Write-Error "Operating System and or Process Architecture Unkown or Unsupported" -ErrorAction Stop
    }
 
    $cliPath = Join-Path $PSScriptRoot .. 'bin' $Hcl2JsonVersion $executableName

    if((test-path $cliPath) -ne $true){
        Write-Error "Problem with the CLI Executable" -ErrorAction Stop
    }

    $output = ($HclContent | & $cliPath | ConvertFrom-Json -Depth 200)
    return $output
}
