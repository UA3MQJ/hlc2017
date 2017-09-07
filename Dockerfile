FROM elixir:1.4.5
MAINTAINER UA3MQJ <UA3MQJ@gmail.com>
ADD . /app
WORKDIR /app
RUN mkdir -p /app/priv
RUN mkdir -p /app/priv/data
RUN apt-get update
RUN apt-get install -y unzip
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile
RUN mix release
EXPOSE 80
CMD ./start.sh
