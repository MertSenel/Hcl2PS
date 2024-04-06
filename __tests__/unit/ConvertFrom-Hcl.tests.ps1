# Define variables
$moduleName = "Hcl2PS" # Replace with your actual module name
$modulePath = "$PSScriptRoot/../../../Hcl2PS" # Replace with the path to your module directory
$localRepositoryPath = "$PSScriptRoot/LocalPSRepository" # Path for your local repository
$localRepositoryName = "LocalPSRepository" # A name for your local repository

# Create a local repository directory if it doesn't already exist
if (-not (Test-Path -Path $localRepositoryPath)) {
    New-Item -ItemType Directory -Path $localRepositoryPath
}

# Register the local repository with PowerShellGet
$repositoryExists = Get-PSRepository | Where-Object { $_.Name -eq $localRepositoryName } | Select-Object -First 1
if ($null -eq $repositoryExists) {
    Register-PSRepository -Name $localRepositoryName -SourceLocation $localRepositoryPath -InstallationPolicy Trusted
} else {
    Write-Host "Repository $localRepositoryName already exists."
}

# Publish the module to the local repository
# Note: You might need to increment the version in the module manifest (.psd1) if republishing
Publish-Module -Path $modulePath -Repository $localRepositoryName -NuGetApiKey "AnyKey" -Force

# Uninstall the module if it's already installed (for testing purposes)
if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName }) {
    Write-Host "Module $moduleName is already installed. Uninstalling for clean test..."
    Uninstall-Module -Name $moduleName -AllVersions -Force
}

# Install the module from the local repository
Install-Module -Name $moduleName -Repository $localRepositoryName -Force

# Verify installation and import the module for testing
if (Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName }) {
    Write-Host "Module $moduleName has been installed successfully from $localRepositoryName."
    # Import-Module $moduleName -Force
    Write-Host "Module $moduleName imported successfully for testing."
} else {
    Write-Host "Failed to install or find $moduleName. Please check the logs above for errors."
}

# Import-Module "$PSScriptRoot/../../Hcl2PS.psd1" -Force


Describe "Test Conversions main.tf" -Tag 'main.tf File Tests' {

    BeforeAll {
        $filePath = ".\..\testData\main.tf"
        write-host "File Path: $filepath"
        $actual = ConvertFrom-Hcl -Path $filePath 
    }
    It "main.tf should have blocks" {

        ($actual | get-member -Type NoteProperty).name | Should -Be @("data", "provider", "resource", "terraform")
    }

    It "main.tf nested property value test" {

        $actual.resource.azurerm_kubernetes_cluster.k8sexample.name | Should -Be '${var.vault_user}-k8sexample-cluster'
    }
}


Describe "Test Conversions outputs.tf" -Tag 'outputs.tf File Tests' {

    BeforeAll {
        $filePath = ".\..\testData\outputs.tf"
        write-host "File Path: $filepath"
        $actual = ConvertFrom-Hcl -Path $filePath
    }
    It "outputs.tf should have outputs" {

        ($actual.output | get-member -Type NoteProperty).name | Should -Be @("environment", 
            "k8s_endpoint", 
            "k8s_id", 
            "k8s_master_auth_client_certificate",
            "k8s_master_auth_client_key", 
            "k8s_master_auth_cluster_ca_certificate", 
            "private_key_pem", 
            "vault_addr",
            "vault_user"
        )
    }

    It "outputs.tf nested property value test" {

        $actual.output.environment.value | Should -Be '${var.environment}'
    }
}

Describe "Test Conversions sample-policy.hcl" -Tag 'sample-policy.hcl File Tests' {

    BeforeAll {
        $filePath = ".\..\testData\sample-policy.hcl"
        write-host "File Path: $filepath"
        $actual = ConvertFrom-Hcl -Path $filePath
    }   

    It "sample-policy.hcl nested property value test" {

        $actual.path.'auth/roger*'.capabilities | Should -Be @('create', 'read', 'update', 'delete', 'list')
    }
}

#######################
#### AsJson Tests #####
#######################
Describe "Test Conversions main.tf with -AsJson" -Tag 'main.tf File Tests with JSON' {

    BeforeAll {
        $filePath = ".\..\testData\main.tf"
        $expectedJsonPath = ".\..\testData\main.json" # Path to the expected JSON file
        write-host "File Path: $filepath"
        $jsonString = ConvertFrom-Hcl -Path $filePath -AsJson
        $actual = $jsonString | ConvertFrom-Json
        $expectedJson = Get-Content $expectedJsonPath
    }

    It "main.tf JSON string should match expected JSON" {
        $jsonString | Should -BeExactly $expectedJson
    }
}

Describe "Test Conversions outputs.tf with -AsJson" -Tag 'outputs.tf File Tests with JSON' {

    BeforeAll {
        $filePath = ".\..\testData\outputs.tf"
        $expectedJsonPath = ".\..\testData\outputs.json" # Path to the expected JSON file
        write-host "File Path: $filepath"
        $jsonString = ConvertFrom-Hcl -Path $filePath -AsJson
        $actual = $jsonString | ConvertFrom-Json
        $expectedJson = Get-Content $expectedJsonPath
    }

    It "outputs.tf JSON string should match expected JSON" {
        $jsonString | Should -BeExactly $expectedJson
    }
}

Describe "Test Conversions sample-policy.hcl with -AsJson" -Tag 'sample-policy.hcl File Tests with JSON' {

    BeforeAll {
        $filePath = ".\..\testData\sample-policy.hcl"
        $expectedJsonPath = ".\..\testData\sample-policy.json" # Path to the expected JSON file
        write-host "File Path: $filepath"
        $jsonString = ConvertFrom-Hcl -Path $filePath -AsJson
        $actual = $jsonString | ConvertFrom-Json
        $expectedJson = Get-Content $expectedJsonPath
    }

    It "sample-policy.hcl JSON string should match expected JSON" {
        $jsonString | Should -BeExactly $expectedJson
    }
}
