#!/bin/sh
set -e

mkdir -p /var/volumes/1c-postgres-data
mkdir -p /var/volumes/1c-server-home
mkdir -p /var/volumes/1c-server-logs
mkdir -p /var/volumes/pgadmin-data
mkdir -p /var/volumes/portainer-data

chmod -R 777 /var/volumes