FROM postgis/postgis:14-3.2-alpine

# Nominatim recommended configuration
COPY --chown=postgres:postgres postgresql.conf /etc/postgresql/postgresql.conf
# Configure 2 parameters for database import
COPY import.sh /docker-entrypoint-initdb.d/

CMD [ "-c", "config_file=/etc/postgresql/postgresql.conf" ]
