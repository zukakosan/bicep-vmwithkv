//reference:https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-secrets

param location string = resourceGroup().location
param kvName string
param usrObjectId string

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: kvName
  location: location
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: usrObjectId
        permissions: {
          // keys: [
          //   'get'
          // ]
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
  name: 'VMAdminPassword'
  properties: {
    value: 'P@ssw0rd1234!'
  }
}
