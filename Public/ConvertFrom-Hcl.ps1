function ConvertFrom-Hcl {
    [CmdletBinding(DefaultParameterSetName = 'Path')]
    param (
        [Parameter(ParameterSetName = 'Path', Mandatory = $true)]
        [string]$Path,
        
        [Parameter(ParameterSetName = 'Pipeline', ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InputObject,

        [switch]$AsJson
    )
    
    # Use the appropriate parameter set based on whether Path or Pipeline input is provided
    if ($PSCmdlet.ParameterSetName -eq 'Path') {
        $HclContent = Get-Content $Path -Raw
    }
    else {
        $HclContent = $InputObject
    }

    $output = $HclContent | & $cliPath

    if (-not $AsJson) {
        if ($PSVersionTable.PSVersion.Major -ge 6) {
            $output = $output | ConvertFrom-Json -Depth 200
        }
        else {
            $output = $output | ConvertFrom-Json
        }
    }
    
    return $output
}
