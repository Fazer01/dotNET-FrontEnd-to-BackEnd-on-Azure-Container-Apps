param name string
param location string = resourceGroup().location
param tags object = {}
param identityName string
param containerAppsEnvironmentName string
param containerRegistryName string
param exists bool
param aiConnectionString string
param serviceName string = 'products'

resource identity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: identityName
  location: location
}

module app '../core/host/container-app-upsert.bicep' = {
  name: '${serviceName}-container-app'
  params: {
    name: name
    location: location
    tags: union(tags, { 'azd-service-name': serviceName })
    identityType: 'UserAssigned'
    identityName: identityName
    exists: exists
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    external: false
    ingressEnabled: true
    containerMaxReplicas: 1
    containerMinReplicas: 0
    env: [
      {
        name: 'ASPNETCORE_ENVIRONMENT'
        value: 'Development'
      }
      {
        name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
        value: aiConnectionString
      }
      {
        name: 'ASPNETCORE_LOGGING__CONSOLE__DISABLECOLORS'
        value: 'true'
      }     
    ]
    targetPort: 8080
  }
}

output SERVICE_PRODUCTS_IDENTITY_PRINCIPAL_ID string = identity.properties.principalId
output SERVICE_PRODUCTS_NAME string = app.outputs.name
output SERVICE_PRODUCTS_URI string = app.outputs.uri
output SERVICE_PRODUCTS_IMAGE_NAME string = app.outputs.imageName
