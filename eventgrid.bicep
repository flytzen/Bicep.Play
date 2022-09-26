var location = 'northeurope'
var systemName = 'fl-eg'
var repoUrl = 'https://github.com/Azure-Samples/azure-event-grid-viewer.git'

resource eventGridTopic 'Microsoft.EventGrid/topics@2022-06-15' = {
  name: '${systemName}-eg'
  location: location
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
    }
    httpsOnly: true
  }
  resource sourceControlIntegration 'sourcecontrols@2022-03-01' = {
    name: 'web'
    properties: {
      repoUrl: repoUrl
      branch: 'main'
      isManualIntegration: true
    }
  }

}

resource eventSubscription 'Microsoft.EventGrid/eventSubscriptions@2022-06-15' = {
  name: '${systemName}-es'
  scope: eventGridTopic
  properties: {
    destination:{
      endpointType: 'WebHook'
      properties:{
        endpointUrl: 'https://${webapp.properties.defaultHostName}/api/updates'
      }
    }
    
  }
  
}

