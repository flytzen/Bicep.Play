var location = 'northeurope'
var systemName = 'fl-webappbicep'

// ** Shared bit **
// !! Re-running the "shared" bit will (most likely) delete existing routing rules!

var frontDoorName = '${systemName}-fd'
//var backendAddress = webapp.properties.defaultHostName
var backendAddress = 'dummy.com'
var frontEndEndpointName = 'frontEndEndpoint'
var loadBalancingSettingsName = 'loadBalancingSettings'
var healthProbeSettingsName = 'healthProbeSettings'
var routingRuleName = 'dummyRoutingRule'
var backendPoolName = 'dummyBackendPool'

resource frontDoor 'Microsoft.Network/frontDoors@2020-05-01' = {
  name: frontDoorName
  location: 'global'
  properties: {
    enabledState: 'Enabled'

    frontendEndpoints: [
      {
        name: frontEndEndpointName
        properties: {
          hostName: '${frontDoorName}.azurefd.net'
          sessionAffinityEnabledState: 'Disabled'
        }
      }
    ]

    loadBalancingSettings: [
      {
        name: loadBalancingSettingsName
        properties: {
          sampleSize: 4
          successfulSamplesRequired: 2
        }
      }
    ]

    healthProbeSettings: [
      {
        name: healthProbeSettingsName
        properties: {
          path: '/'
          protocol: 'Http'
          intervalInSeconds: 120
        }
      }
    ]

    backendPools: [
      {
        name: backendPoolName
        properties: {
          backends: [
            {
              address: backendAddress
              backendHostHeader: backendAddress
              httpPort: 80
              httpsPort: 443
              weight: 50
              priority: 1
              enabledState: 'Enabled'
            }
          ]
          loadBalancingSettings: {
            id: resourceId('Microsoft.Network/frontDoors/loadBalancingSettings', frontDoorName, loadBalancingSettingsName)
          }
          healthProbeSettings: {
            id: resourceId('Microsoft.Network/frontDoors/healthProbeSettings', frontDoorName, healthProbeSettingsName)
          }
        }
      }
    ]

    routingRules: [
      {
        name: routingRuleName
        properties: {
          frontendEndpoints: [
            {
              id: resourceId('Microsoft.Network/frontDoors/frontEndEndpoints', frontDoorName, frontEndEndpointName)
            }
          ]
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          patternsToMatch: [
            '/__dummy'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            forwardingProtocol: 'MatchRequest'
            backendPool: {
              id: resourceId('Microsoft.Network/frontDoors/backEndPools', frontDoorName, backendPoolName)
            }
          }
          enabledState: 'Disabled'
        }
      }
    ]
  }
}

// TODO: See if we can run some CLI here to delete the dummy backend pool and routing rule

// ** individual environment bit **

resource appserviceplan 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: '${systemName}-asp'
  location: location
  sku:{
    name: 'S1'
  }
  kind: 'linux'
  tags: {
     'Scale': 'Temporary'
  }
  properties: {
    reserved: true
  }
}


resource webapp 'Microsoft.Web/sites@2021-03-01' = {
  name: '${systemName}-web'
  location: location
  properties: {
    serverFarmId:appserviceplan.id
    siteConfig: {
      ipSecurityRestrictions: [
        // https://docs.microsoft.com/en-us/azure/app-service/app-service-ip-restrictions
      ]
    }
  }
  tags: {
    'Scale': 'Temporary'
  }
}

resource webappBackendPool 'Microsoft.Network/frontDoors/rulesEngines@2020-05-01' = {
  name: 'webapp'
  parent: frontDoor
  properties: {
    rules: [
      
    ]
  }
}



// https://github.com/Azure/bicep/issues/3834#issuecomment-890005732 for merging load balancer settings ??
// Part of the problem, of course, is that we have no way to remove rules we no longer want!
// " new front door standard/premium. It???s based on CDN (in bicep you define it as cdn/profiles with frontdoor sku) and it???s much more flexible than the Microsoft.Network/frontdoor."
// => https://github.com/Azure/bicep/issues/3834#issuecomment-890057629  ??


resource x 'Microsoft.Cdn/profiles@2021-06-01'
















// This is the kind of circular reference that is tough in Pulumi
// resource webAppAccessRestrictionToFrontDoor 'Microsoft.Web/sites/config@2021-03-01' = {
//   name: 'web'
//   parent: webapp
//   properties: {
//     ipSecurityRestrictions:[
//       {
//         'ipAddress': 'AzureFrontDoor.Backend'
//         'tag': 'ServiceTag'
//         'action': 'Allow'
//         'priority': 300
//         'name': 'Aure Front Door example'
//         'headers': {
//           'x-azure-fdid': [
//             frontDoor.properties.frontdoorId
//           ]
//         }
//       }
//     ]
//   }  
// }
