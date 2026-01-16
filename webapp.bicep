param location string = 'westus2'
param appServicePlanName string = 'AamribicepAppServicePlan2'
param webAppName string = 'AamribicepWebAppDemo2'

resource appServicePlan 'Microsoft.Web/serverfarms@2025-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

resource webApp 'Microsoft.Web/sites@2025-03-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}