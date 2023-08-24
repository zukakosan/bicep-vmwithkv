
param kvName string
param vmAdminUserName string
@secure()
param vmAdminPassword string
param usrObjId string

param vnetName string = 'vnet-cloud'
param subnetName string = 'subnet-main'
param vmName string = 'vm-cloud'


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

// execute modules

module CreateVnet './modules/vnet.bicep' = {
  name: 'create-vnet-module'
  params: {
    location: resourceGroup().location
    vnetName: vnetName
    subnetName: subnetName
  }
}

module CreateVM './modules/vm.bicep' = {
  name: 'create-vm-module'
  params: {
    location: resourceGroup().location
    vmName: vmName
    vnetName: vnetName
    subnetName: subnetName
    vmAdminUserName: vmAdminUserName
    vmAdminPassword: keyVault.getSecret('vmAdminPassword')
  }
  dependsOn: [
    CreateVnet
  ]
}
