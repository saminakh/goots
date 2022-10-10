FROM bitwalker/alpine-elixir-phoenix:latest AS build

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod \
    BOT_TOKEN=${BOT_TOKEN} \
    VOICE_CHANNEL_ID=${VOICE_CHANNEL_ID}

# install mix dependencies
COPY mix.exs mix.lock version.txt ./
COPY config config
RUN mix do deps.get, deps.compile

# build project
COPY lib lib
RUN mix compile

# build assets
COPY assets assets
COPY priv priv
# RUN npm i -g yarn
# RUN cd assets && yarn && yarn deploy
# RUN mix phx.digest

# build release (uncomment COPY if rel/ exists)
COPY rel rel
RUN mix release

# prepare release image
FROM bitwalker/alpine-elixir:1.12.3 AS app
RUN apk add --update bash openssl jq

RUN mkdir /app
WORKDIR /app

COPY --from=build /app/_build/prod/rel/goots ./

RUN chown -R nobody: /app
USER nobody

EXPOSE 8443

ENV HOME=/app
CMD ["bin/goots", "start"]

