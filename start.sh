#!/bin/sh

set -e

echo "run db migration"
/app/migrate -path /app/migration -database "postgresql://root:YVpMHu4nBJxqkUDMS85a@simple-bank.cev0k397mf6f.ap-south-1.rds.amazonaws.com:5432/simple_bank" -verbose up

echo "start the app"
exec "$@"