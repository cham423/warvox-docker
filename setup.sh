#!/bin/bash
#
# based of a setup script by pandrew/metasploit
#

USEREXIST="$(psql -h $DB_PORT_5432_TCP_ADDR -p 5432 -U postgres postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='$VOXUSER'")"
if [[ ! $USEREXIST -eq 1 ]]
then
  psql -h $DB_PORT_5432_TCP_ADDR -p 5432 -U postgres postgres -c "create role $VOXUSER WITH SUPERUSER login password '$VOXPASS'"
fi

DBEXIST="$(psql -h $DB_PORT_5432_TCP_ADDR -p 5432 -U postgres  postgres -l | grep warvox)"
if [[ ! $DBEXIST ]]
then
  psql -h $DB_PORT_5432_TCP_ADDR -p 5432 -U postgres postgres -c "CREATE DATABASE warvox OWNER $VOXUSER;"
fi

sh -c "echo 'production:
  adapter: postgresql
  database: warvox
  username: $VOXUSER
  password: $VOXPASS
  host: $DB_PORT_5432_TCP_ADDR
  port: 5432
  pool: 75
  timeout: 5' > /home/warvox/config/database.yml"

cd /home/warvox 
make database
cp /home/warvox/config/secrets.yml.example /home/warvox/config/secrets.yml
bin/adduser $ADMINUSER $ADMINPASS
bin/warvox.rb --address 0.0.0.0
