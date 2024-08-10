#!/bin/bash

set -e

function waitForGis() {
  # wait for gis container to reach a ready state
  while ! psql --list > /dev/null 2>&1
  do
    echo "Connecting to $PGHOST..."
    sleep 5
  done
}

function waitForGisDatabase() {
  # wait for gis container to reach a ready state
  while ! psql --list | grep $1 > /dev/null 2>&1
  do
    echo "Waiting for $PGHOST/$1..."
    sleep 10
  done
}

if [ "$1" = 'api' ]; then
  # uvicorn ASGI
  waitForGis
  waitForGisDatabase nominatim

  # uvicorn uses the WEB_CONCURRENCY env variable for multiple worker processes
  # modify WEB_CONCURRENCY in docker-compose.yaml
  exec python3 -m uvicorn nominatim.server.falcon.server:run_wsgi \
    --proxy-headers --host 0.0.0.0 --port 8000 --factory
fi

exec "$@"
