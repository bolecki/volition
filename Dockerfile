FROM elixir

MAINTAINER Brian Olecki <bolecki019@gmail.com>

ENV PHOENIX_VERSION 1.2.1

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new-$PHOENIX_VERSION.ez
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && apt-get install -y nodejs
RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /code
ENTRYPOINT ["mix", "phoenix.server"]
