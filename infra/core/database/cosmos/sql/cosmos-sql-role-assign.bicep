param accountName string

param roleDefinitionId string
param principalId string = ''

resource role 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-11-15' = {
  parent: cosmos
  name: guid(roleDefinitionId, principalId, cosmos.id)
  properties: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    scope: cosmos.id
  }
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2023-11-15' existing = {
  name: accountName
}
