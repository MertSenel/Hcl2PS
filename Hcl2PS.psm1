﻿$Script:Hcl2JsonVersion = '0.5.0'

foreach ($directory in @('Public', 'Private')) {
    Get-ChildItem -Path "$PSScriptRoot\$directory\*.ps1" | ForEach-Object { . $_.FullName }
}
