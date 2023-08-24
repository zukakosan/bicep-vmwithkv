param kvName string
param usrObjId string
param vmAdminUserName string
@secure()
param vmAdminPassword string 

// Create Azure Key Vault to store secret for VM Admin Password
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: kvName
  location: resourceGroup().location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: usrObjId
        permissions: {
          secrets: [
            'list'
            'get'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

resource keyVaultSecret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  parent: keyVault
  name: 'vmAdminPassword'
  properties: {
    value: vmAdminPassword
  }
}

// main module
module main 'main.bicep' = {
  name: 'main'
  params: {
    kvName: keyVault.name
    vmAdminUserName: vmAdminUserName
    // vmAdminPassword: keyVaultSecret.properties.value
  }
}
