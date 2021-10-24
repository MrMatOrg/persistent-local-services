# Persistent Local Services

A simple turnkey solution to run commonly used services with persistence, but locally. So you can save money on expensive clouds when it's really not necessary. Oh and did I mention that this will still work when you have no or only an untrusted Internet connection? Say you're on a plane or something?

This currently spins up the following via docker-compose. Docker-desktop is consequently a prerequisite.

| Service | Implementation | Exposed on |
|---------|----------------|------------|
| Relational Database | PostgreSQL 14.0 | 127.0.0.1:5432 | 
| Auth/z/n | Keycloak 15.0.1 | 127.0.0.1:8080 |

>Note that this solution is deliberately persisting its data. It can be useful for unit tests but it is more likely that you wish this to be more ephemeral for integration tests.

## How to use this

### Start with default configuration

0. You need something that knows how to deal with Docker compose files (e.g. Docker Desktop, but podman should also work)

1. Clone this repository somewhere

2. Navigate to the directory containing docker-compose.yml and start services with their default configuration. If you feel confident, you can add `-d` at the end to start in detached mode. Otherwise hit Ctrl-C to exit the services running in the foreground.

```shell
$ docker compose up
```

### Configuration

You can create an .env file and point docker compose to it via its `--env-file` option. This will override the following variables. For your convenience, `local.env` is explicitly git-ignored so you can simply do a git pull to update.

| Environment Variable | Default | Description |
|----------------------|---------|-------------|
| INFRA_PERSISTENCE_DB | ./data/db | Persistence directory for the database |
| INFRA_PERSISTENCE_KEYCLOAK | ./data/keycloak | Persistence directory for Auth/z/n. Keycloak is configured to store its data in the database. This directory is only used for importing/exporting realm configurations |
| INFRA_DB_NAME        | localdb | Name of the PostgreSQL database to spin up |
| INFRA_DB_PASSWORD    | foobar  | Password for the postgres user |
| INFRA_KEYCLOAK_USER  | keycloak | Admin user for Keycloak |
| INFRA_KEYCLOAK_PASSWORD | foobar | Password for the keycloak user |

To then execute with your local configuration overrides:

```shell
$ docker compose --env-file /path/to/local.env up
```

### Starting and Stopping

```shell
$ docker compose start
$ docker compose stop
```

## How to hack this

* There's little to no security. Don't expect there to be any.
* docker-compose will start keycloak right after postgres is started, even though postgres must still configure a schema and role for it. There's a clever little script checking whether port 5432 is responsive from the perspective of the keycloak container image and it will sleep if it is not.
* There is zero security for the credentials that keycloak uses to connect to postgres and they cannot currently be overridden unless you edit `pg-init.d/init-db-keycloak.sh` as well as `docker-compose.yml`
* Be super-sure when editing on Windows that the line endings of the shell scripts mounted from keycloak-init.d and pg-init.d have LF line-endings.
* Unless you are running on Linux, the directory from which we mount the init.d scripts as well as the persisted directories must be mountable by Docker. You can configure that in the docker UI.
