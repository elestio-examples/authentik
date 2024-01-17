#!/usr/bin/env bash

AUTHENTIK_SECRET_KEY=${AUTHENTIK_SECRET_KEY:=`openssl rand -base64 36`}

cat << EOT >> ./.env

AUTHENTIK_SECRET_KEY=${AUTHENTIK_SECRET_KEY}
EOT

mkdir -p ./gen-ts-api
mkdir -p ./gen-go-api

docker buildx build . --output type=docker,name=elestio4test/authentik-server:latest | docker load