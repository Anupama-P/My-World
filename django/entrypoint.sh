#!/bin/bash
set -e
cmd="$@"

if [ -z "$DATABASE_URL" ]; then
    export DATABASE_URL=postgres://postgres:postgres@postgres:5432/postgres
fi
echo $DATABASE_URL

function postgres_ready(){
python << END
import sys
import psycopg2
try:
    conn = psycopg2.connect("$DATABASE_URL")
except psycopg2.OperationalError:
    sys.exit(-1)
sys.exit(0)
END
}

until postgres_ready; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - continuing..."

# -z tests for empty, if TRUE, $cmd is empty
if [ -z $cmd ]; then
  >&2 echo "Running default command (migrate + gunicorn)"
  python /app/manage.py migrate --noinput
      pip install -r /app/requirements.txt
      /usr/local/bin/gunicorn config.wsgi -b 0.0.0.0:5000 -t 3600 --chdir=/app --reload
else
  >&2 echo "Running command passed (by the compose file)"
  exec $cmd
fi
