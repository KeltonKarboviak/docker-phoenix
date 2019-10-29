# Dockerized Elixir/Phoenix Development Environment

### Introduction

Inspired from [nicbet/docker-phoenix](https://github.com/nicbet/docker-phoenix).

### New: Support for VS Code Remote Extension

After cloning this repository, open the folder in Visual Studio Code's Remote Extension to get a
full Development Environment (with PostgreSQL Database) spun up automatically.

See [https://code.visualstudio.com/docs/remote/containers](https://code.visualstudio.com/docs/remote/containers)
for more details.

### Getting Started

It's so simple: just clone this repository.

You can specify a particular Phoenix version by targeting the corresponding release tag of this repository.

For instance, for a dockerized development environment for Phoenix 1.4.10 you could run:

```bash
git clone -b 1.4.10 https://github.com/nicbet/docker-phoenix ~/Projects/hello-phoenix
```

### New with Elixir 1.9: Releases

Follow this [Github Gist](https://gist.github.com/nicbet/102f16359828405ce34ca083976986e1) to prepare a minimal Docker release image based on Alpine Linux (about 38MB for a Phoenix Webapp).

### New Application from Scratch

Navigate the to where you cloned this repository, for example:

```bash
cd ~/Projects/hello-phoenix
```

Initialize a new phoenix application. The following command will create a new Phoenix application called `hello` under the `src/` directory, which is mounted inside the container under `/app` (the default work dir).

```bash
./mix phx.new . --app hello
```

Why does this work? The `docker-compose.yml` file specifies that your local `src/` directory is mapped inside the docker container as `/app`. And `/app` in the container is marked as the working directory for any command that is being executed, such as `mix phoenix.new`.

**NOTE:** It is important to specify your app name through the `--app <name>` option, as Phoenix will otherwise name your app from the target directory passed in, which in our case is `.`

**NOTE:** It is okay to answer `Y` when phoenix states that the `/app` directory already exists.

**NOTE:** Starting from 1.3.0 the `mix phoenix.new` command has been deprecated. You will have to use the `phx.new` command instead of `phoenix.new` or `mix deps.get` will fail!

### Alternative: Existing Application

Copy your existing code Phoenix application code to the `src/` directory in the cloned repository.

**NOTE:** the `src/` directory won't exist so you'll have to create it first.

### Database

#### Preparation

The `docker-compose.yml` file defines a database service container named `db` running a PostgreSQL database that is available to the main application container via the hostname `db`. By default Phoenix assumes that you are running a database locally.

Modify the Ecto configuration `src/config/dev.exs` to point to the DB container:

```elixir
# Configure your database
config :test, Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "test_dev",
  hostname: "db",
  pool_size: 10
```

#### Initialize the Database with Ecto

When you first start out, the `db` container will have no databases. Let's initialize a development DB using Ecto:

```bash
./mix ecto.create
```

If you copied an existing application, now would be the time to run your database migrations.

```bash
./mix ecto.migrate
```

### Starting the Application

Starting your application is incredibly easy:

```bash
docker-compose up
```

Once up, it will be available under <http://localhost:4000>.

## Notes

### Executing custom commands

To run commands other than `mix` tasks, you can use the `./run` script.

```bash
./run iex -S mix
```
