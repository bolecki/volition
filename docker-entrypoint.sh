#!/bin/bash

mix ecto.create
mix ecto.migrate
yes n | mix phoenix.gen.presence
mix phoenix.server
