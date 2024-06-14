# Goots

A dumb bot to play youtube in discord because youtube took down fredboat

## Setup

You will need:

  * A bot token. Get one from the [discord developer portal](https://discord.com/developers/applications/).

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployment

This app is deployed using fly.io.

Make sure your bot token and yt api key (for fetching ty metadata) are secrets
set on fly.io

  * use `fly launch` to launch your application.
  * use `fly deploy` to deploy new changes
  * use `fly proxy 5433:5432 -a app-name-db` to proxy into your db
