Install-Module -Name Hcl2PS -Force
Import-Module -Name Hcl2PS -Force

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

        $actual.path.'auth/roger*'.capabilities | Should -Be @('create','read','update','delete','list')
    }
}