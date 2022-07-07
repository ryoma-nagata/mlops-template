param location string
param tags object

param WorkspaceName string 
param amlStorageName string

param applicationinsightName string 

param containerRegistryName string
param keyVaultName string


module amlStorage 'storage.bicep' = {
  name: amlStorageName
  params: {
    tags:tags
    fileSystemNames: []
    isHnsEnabled: false
    location: location
    storageName: amlStorageName
    storageSKU: 'Standard_RAGRS'
  }
}
module amlApplicationInsight 'applicationinsight.bicep' = {
  name: applicationinsightName
  params: {
    tags:tags
    applicationinsightName: applicationinsightName
    location: location
  }
}

module amlContainerRegistry 'containerregistry.bicep' = {
  name: containerRegistryName
  params: {
    tags:tags
    containerRegistryName: containerRegistryName
    location: location
  }
}
module amlkeyvault 'keyvault.bicep' = {
  name: keyVaultName
  params: {
    keyvaultName: keyVaultName
    location: location
    tags: tags
  }
}

resource machinelearning 'Microsoft.MachineLearningServices/workspaces@2022-01-01-preview' = {
  name: WorkspaceName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    friendlyName: WorkspaceName
    keyVault: amlkeyvault.outputs.keyvaultId
    applicationInsights: amlApplicationInsight.outputs.applicationinsightId
    containerRegistry: amlContainerRegistry.outputs.containerRegistryId
    storageAccount: amlStorage.outputs.storageId
  }
}

resource cpucluster 'Microsoft.MachineLearningServices/workspaces/computes@2022-05-01' = {
  parent:machinelearning
  name: 'cpu-cluster' 
  location: location
  properties:{
    computeType: 'AmlCompute' 
    properties:{
      osType: 'Linux'
      scaleSettings: {
        minNodeCount: 0
        maxNodeCount: 1
        nodeIdleTimeBeforeScaleDown: 'PT120S'
      }
      vmPriority: 'LowPriority'
      vmSize: 'STANDARD_DS11_V2'
      }
    }
}



output machinelearningWorkspaceId string = machinelearning.id
output containerRegistryId string = amlContainerRegistry.outputs.containerRegistryId
output mlstorageId string = amlStorage.outputs.storageId
output machinelearningPrincipalId string = machinelearning.identity.principalId
