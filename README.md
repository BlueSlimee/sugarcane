# Sugarcane

*please don't judge me, this is my first actual elixir project!!*
Yet another simple Discord bot, focused on moderation.

## Setting it up

> NOTE: btw, you'll need to set up a postgres instance

- Rename `config/config.exs.sample` to `config/config.exs`
- Fill out everything you need to (database credentials, tokens, etc)
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup` and `mix ecto.migrate`
- Now, you can use `iex -S mix` to start the bot!
