#!/bin/bash
set -e

psql -d "$POSTGRES_DB" -U "$POSTGRES_USER" <<-EOSQL
    CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replicator_passwd';
    SELECT * FROM pg_create_physical_replication_slot('replication_slot_slave1');
EOSQL

# backup database
echo "backup database"
pg_basebackup -D /tmp/postgres_slave -S replication_slot_slave1 -X stream -P -U replicator -Fp -R