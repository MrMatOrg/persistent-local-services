#
# Create local, persistent infrastructure

#
# Set some defaults

$LocalConfiguration = "${Env:USERPROFILE}\etc\persistent-local-services.ps1"

$Env:INFRA_BASE=$PSScriptRoot
$Env:COMPOSE_FILE="${Env:INFRA_BASE}/persistent-local-services.yml"
$Env:INFRA_PERSISTENCE_DB="${Env:INFRA_BASE}/data/db"
$Env:INFRA_PERSISTENCE_KEYCLOAK="${Env:INFRA_BASE}/data/keycloak"

#
# See if we have a local override

if (Test-Path -Path $LocalConfiguration -PathType Leaf) {
    Write-Host "Configuring from ${LocalConfiguration}"
    . $LocalConfiguration
} else {
    Write-Host "Using default configuration"
}

#
# Start up

docker compose up -d
