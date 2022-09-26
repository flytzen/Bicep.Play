var location = 'northeurope'
var systemName = 'fl-cdn'
var repoUrl = 'https://github.com/Azure-Samples/app-service-web-html-get-started.git'

// TODO: Add logging to log analytics of relevant things from the Front Door
// This doesn't work (see https://github.com/Azure/bicep/issues/8494)
// Putting this up here to test creating a shared profile used by different environments
resource frontdoorProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: '${systemName}-cp'
  location: 'global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  tags: {
    Scale: 'Normal'
  }
}


resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: '${systemName}-asp'
  location: location
  properties:{}
  sku: {
    name: 'S1'
  }
  tags: {
    Scale: 'Normal'
  }
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: '${systemName}-web'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      webSocketsEnabled: true
      netFrameworkVersion: 'v6.0'
      ipSecurityRestrictions: [
        {
          tag: 'ServiceTag'
          ipAddress: 'AzureFrontDoor.Backend'
          action: 'Allow'
          priority: 100
          headers: {
            'x-azure-fdid': [
              frontdoorProfile.properties.frontDoorId
            ]
          }
          name: 'Allow traffic from Front Door'
        }
      ]
    }
    httpsOnly: true
  }
  resource sourceControlIntegration 'sourcecontrols@2022-03-01' = {
    name: 'web'
    properties: {
      repoUrl: repoUrl
      branch: 'master'
      isManualIntegration: true
    }
  }
}

// You would probabbly have one or more of these, specific to a particular environment
resource mainEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  parent: frontdoorProfile
  name: '${systemName}-ep'
  location: 'Global'
}

// This is where we start to reference the web app
resource originGroup 'Microsoft.Cdn/profiles/originGroups@2022-05-01-preview' = {
  parent: frontdoorProfile
  name: '${systemName}-og'
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
    }
  }
// TODO: Fix this one
  resource webappOrigin 'origins' = {
    name: '${webapp.name}-origin'
    properties: {
      enabledState:'Enabled'
      azureOrigin: {
        id: webapp.id
      }
    }
  }
}

