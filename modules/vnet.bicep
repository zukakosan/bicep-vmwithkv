param location string
param vnetName string
param subnetName string

// Create Network Security Group before VNet to attach NSG to Subnet
resource VNetCloudNSG 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'vnet-cloud-nsg'
  location: location
  properties: {
    // securityRules: [
    //   {
    //     name: 'nsgRule'
    //     properties: {
    //       description: 'description'
    //       protocol: 'Tcp'
    //       sourcePortRange: '*'
    //       destinationPortRange: '*'
    //       sourceAddressPrefix: '*'
    //       destinationAddressPrefix: '*'
    //       access: 'Allow'
    //       priority: 100
    //       direction: 'Inbound'
    //     }
    //   }
    // ]
  }
}
// Create VNet
resource VNetCloud 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup: {
            id: VNetCloudNSG.id
          }
        }
      }
      // {
      //   name: 'subnet-pe'
      //   properties: {
      //     addressPrefix: '10.0.1.0/24'
      //     networkSecurityGroup: {
      //       id: VNetCloudNSG.id
      //     }
      //   }
      // }
    ]
  }
}
