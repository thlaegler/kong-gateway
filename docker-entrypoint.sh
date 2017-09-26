#!/bin/sh
set -e

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

# Setting default prefix (override any existing variable)
export KONG_PREFIX="/usr/local/kong"

# Prepare Kong prefix
if [ "$1" = "/usr/local/openresty/nginx/sbin/nginx" ]; then
	kong prepare -p "/usr/local/kong"
fi

# debug-only
# ----------
#PGHOST=$KONG_PG_HOST
#export PGPASSWORD=$KONG_PG_PASSWORD

# Start the DB proxy
./cloud_sql_proxy -instances=example:australia-southeast1:example-db-postgresql=tcp:5432 &

# debug-only
# ----------
#echo 'select now();' > test.sql
#psql -U $KONG_PG_USER kong < test.sql 

exec "$@"
