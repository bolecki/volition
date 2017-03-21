#!/bin/bash

./wait-for-it.sh db:5432
mix ecto.create
mix ecto.migrate
yes n | mix phoenix.gen.presence
mix volition.loader
mix phoenix.server
