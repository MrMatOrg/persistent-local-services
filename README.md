# Persistent Local Services

A simple turnkey solution to run commonly used services with persistence, but locally. So you can save money on expensive clouds when it's really not necessary. Oh and did I mention that this will still work when you have no or only an untrusted Internet connection? Say you're on a plane or something?

This currently spins up the following via docker-compose. Docker-desktop is consequently a prerequisite.

| Service | Implementation | Exposed on |
|---------|----------------|------------|
| Relational Database | PostgreSQL 14.0 | 127.0.0.1:5432 | 
| Auth/z/n | Keycloak 15.0.1 | 127.0.0.1:8080 |

>Note that this solution is deliberately persisting its data. It can be useful for unit tests but it is more likely that you wish this to be more ephemeral for integration tests.

## How to use this

0. You need something that knows how to deal with Docker compose files (e.g. Docker Desktop, but podman should also work)

1. Clone this repository somewhere

2. Start locally persistent infrastructure with default locations. Choices:

In Bash:

```shell
$ ./up.sh
```

In Powershell:

```powershell
PS > ./up.ps1
```

Directly:

```shell
$ INFRA_BASE=/where/persistent-local-infra.yml/is/located
$ COMPOSE_FILE="${INFRA_BASE}/persistent-local-infra.yml" docker compose up
```

### Configuration

| Environment Variable | Default | Description |
|----------------------|---------|-------------|
| INFRA_BASE           | None    | Set by wrappers to the directory in which they reside. This is taken as the base for the bind mounts |
| INFRA_PERSISTENCE_DB | $INFRA_BASE/db | Persistence directory for the database |
| INFRA_PERSISTENCE_KEYCLOAK | $INFRA_BASE/keycloak | Persistence directory for Auth/z/n. Keycloak is configured to store its data in the database. This directory is only used for importing/exporting realm configurations |
| INFRA_DB_NAME        | localdb | Name of the PostgreSQL database to spin up |
| INFRA_DB_PASSWORD    | foobar  | Password for the postgres user |
| INFRA_KEYCLOAK_USER  | keycloak | Admin user for Keycloak |
| INFRA_KEYCLOAK_PASSWORD | foobar | Password for the keycloak user |

The `up.ps1` script will use your own defaults from `${Env:USERPROFILE}\etc\persistent-local-services.ps1` if that file exists. Place your configuration into this file like this:

```powershell
$Env:INFRA_PERSISTENCE_DB = "d:\data\pg"
$Env:INFRA_PERSISTENCE_KEYCLOAK = "d:\data\keycloak"
$Env:INFRA_DB_NAME = "harkdb"
```

## How to hack this

* There's little to no security. Don't expect there to be any.
* docker-compose will start keycloak right after postgres is started, even though postgres must still configure a schema and role for it. There's a clever little script checking whether port 5432 is responsive from the perspective of the keycloak container image and it will sleep if it is not.
* There is zero security for the credentials that keycloak uses to connect to postgres and they cannot currently be overridden unless you edit `pg-init.d/init-db-keycloak.sh` as well as `persistent-local-infra.yml`
