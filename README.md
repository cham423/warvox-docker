# Requirements
- pwgen (brew or apt install pwgen)
- docker-compose version 3.9 support

# Usage
- Clone Repo
- Change passwords marked as "changeme" in docker-compose.yml
- `docker-compose up -d`
- Navigate to http://127.0.0.1:7777
- Login with admin credentials

# Notes
- Remove postgres-data directory if you need to re-create the containers or change credentials
