#
# Create local, persistent infrastructure

#
# Set some defaults

LocalConfiguration="~/etc/persistent-local-services"
INFRA_BASE=$(cd `dirname $0` && pwd)
COMPOSE_FILE="${INFRA_BASE}/persistent-local-services.yml"
INFRA_PERSISTENCE_DB="${INFRA_BASE}/data/db"
INFRA_PERSISTENCE_KEYCLOAK="${INFRA_BASE}/data/keycloak"
export INFRA_BASE COMPOSE_FILE INFRA_PERSISTENCE_DB INFRA_PERSISTENCE_KEYCLOAK

#
# See if we have a local override

if [ -e "$LocalConfiguration" ]; then
  echo "Configuring from ${LocalConfiguration}"
  . $LocalConfiguration
else
  echo "Using default configuration"
fi

#
# Start up

docker compose up -d
