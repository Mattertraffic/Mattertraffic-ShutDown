param(
  [string]$SubscriptionId = "2d0b7613-743e-46af-9bdf-8c1596a449cb",
  [string]$ResourceGroup = "Mattertraffic-ShutDown",
  [string]$StaticWebAppName = "Mattertraffic-ShutDown",
  [string]$AppPath = "."
)

$ErrorActionPreference = 'Stop'

az account set --subscription $SubscriptionId | Out-Null

$deploymentToken = az staticwebapp secrets list `
  --name $StaticWebAppName `
  --resource-group $ResourceGroup `
  --query "properties.apiKey" `
  -o tsv

if ([string]::IsNullOrWhiteSpace($deploymentToken)) {
  throw "Failed to retrieve Azure Static Web Apps deployment token."
}

npx --yes @azure/static-web-apps-cli deploy $AppPath --deployment-token $deploymentToken --env production
