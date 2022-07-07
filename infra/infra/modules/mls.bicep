targetScope = 'resourceGroup'

param location string 
param env string 
param prefix string
param tags object

var tagsJoin = union(tags,
  {Environment:env}
)


module machinelearning 'services/machinelearning.bicep' ={
  name: 'machinelearning-${env}'
  params: {
    location: location
    tags: tagsJoin
    WorkspaceName: '${prefix}-ml-${env}'
    amlStorageName: '${prefix}-mlst-${env}'
    applicationinsightName: '${prefix}-mlai-${env}'
    containerRegistryName: '${prefix}-mlcr-${env}'
    keyVaultName:  '${prefix}-kv-${env}'
  }
}


// module machinelearning 'services/machinelearning.bicep' ={
//   name: 'machinelearning-${envs}[0]'
//   params: {
//     location: location
//     tags: tags
//     WorkspaceName: '${prefix}-ml-${env}'
//     amlStorageName: '${prefix}-mlst-${env}'
//     applicationinsightName: '${prefix}-mlai-${env}'
//     containerRegistryName: '${prefix}-mlcr-${env}'
//     keyVaultName:  '${prefix}-kv-${env}'
//   }
// }
