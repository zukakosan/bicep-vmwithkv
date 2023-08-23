param location string
// param subnetId string
param vnetName string
param subnetName string
param vmName string
param vmAdminUserName string
@secure()
param vmAdminPassword string

resource VNET 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' existing = {
  name: subnetName
  parent: VNET
}

resource VMCloudNic 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'vm-cloud-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
  }
}


resource windowsVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: vmName
      adminUsername: vmAdminUserName
      adminPassword: vmAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        name: 'vm-cloud-win-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: VMCloudNic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: false
      }
    }
  }
}

output windowsVMId string = windowsVM.id
output windowsVMName string = windowsVM.name
