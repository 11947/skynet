#!/bin/bash
set -e

if [ "$1" = "ragent" ]; then
  echo "Starting 1C server..."
  exec gosu usr1cv8 /opt/1C/v8.3/x86_64/ragent
fi

exec "$@"
