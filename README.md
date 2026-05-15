# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Docker

This app uses three Docker Compose files:

- `docker-compose.yml` — base config shared by all environments (postgres service, app skeleton)
- `docker-compose.override.yml` — dev overrides, **loaded automatically** by Docker Compose alongside the base
- `docker-compose.prod.yml` — production overrides, must be passed **manually** with `-f`

### Development

```bash
docker compose up
```

### Production

Before the first run, create a `.env` file in the project root:

```
SECRET_KEY_BASE=<run: openssl rand -hex 64>
HOUSE_KEEP_DATABASE_PASSWORD=<choose a password>
```

Start:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

Stop:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml down
```

Logs:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml logs -f
```

Tip: add an alias to avoid repeating the `-f` flags:

```bash
alias dc-prod='docker compose -f docker-compose.yml -f docker-compose.prod.yml'
```

# TODO
- finish bill crud
- add image with the bill logo
- add crud on home
