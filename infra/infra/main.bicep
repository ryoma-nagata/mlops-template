
// targetScope = 'subscription'
targetScope = 'resourceGroup'

// general 

@minLength(3)
@maxLength(12)
param project string 

@description('リソースのデプロイリージョン')
@allowed([
  'southcentralus'
  'southeastasia'
  'japaneast'
])
param location string = 'japaneast'
@description('リソース名はproject-リソース種類-envとなります')
param env array = [
  'dev'
  'prd'
]


var prefix  = toLower('${project}')


var tags = {
  Project : project
  DeployMethod : 'bicep'
}


module mls 'modules/mls.bicep' =[for envName in env: {
  name: 'mls-${envName}'
  params: {
    env: envName
    prefix: prefix
    tags:tags
    location:location
  }
}] 
