@{
    RootModule        = 'Hcl2PS.psm1'
    ModuleVersion     = '0.5.0'
    GUID              = 'b6e667f0-dee0-4f7c-acb7-d57d09d4c0d8'
    Author            = 'Mert Senel'
    CompanyName       = 'Mert Senel'
    Copyright         = 'c 2023 All rights reserved.'

    Description       = @'
    PowerShell Module to Wrap Hcl2Json CLI tool for Easy distribution of PowerShell cmdlets to Parse HCL Files
    It can be used to Parse Terraform and other HCL format files into Powershell objects to be used in programmatical access in powershell scripts in DevOps use cases.
'@

    FunctionsToExport = @(
		'ConvertFrom-Hcl'
    )

    AliasesToExport   = @(

    )

    PrivateData       = @{
        PSData = @{
            Category   = "PowerShell Hcl2PS Module"
            Tags       = @("PowerShell", "HCL", "Terraform")
            ProjectUri = "https://github.com/MertSenel/Hcl2PS"
            LicenseUri = "https://github.com/MertSenel/Hcl2PS/blob/main/LICENSE.txt"
        }
    }
}