#!/bin/sh

echo "Updating OpenWebUI container..."

docker container run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui
