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

### Connecting to the running app

The service is named `app` (the background job process is `worker`).

Rails console in production:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec app bin/rails console
```

Shell inside the production container:

```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml exec app bash
```

`RAILS_ENV=production` is already baked into the image, so there is no need to pass it.

In development the same commands work without the `-f` flags:

```bash
docker compose exec app bin/rails console
docker compose exec app bash
```

Note the difference between `exec` and `attach`: `exec` starts a **new** process in the container
and is what you want for a console or a shell. `docker compose attach app` connects to the
**running** server process instead — use it in development to reach a `debugger` breakpoint, which
works because the dev service sets `stdin_open` and `tty`. The production service does not set
them, so attaching there only streams output. Detach with `Ctrl-P Ctrl-Q` so you don't kill the
process.
