#!/bin/sh

docker run --name pg1c16 \
  --net host \
  --detach \
  --volume postgrespro-1c-data:/data \
  --volume /etc/localtime:/etc/localtime:ro \
  --env POSTGRES_PASSWORD=password \
  --restart always \
  pg1c16
