FROM debian:12-slim AS build

# https://nominatim.org/release-docs/develop/appendix/Install-on-Ubuntu-22/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    lbzip2

ENV NOMINATIM_VERSION=4.4.0

# Fetch
WORKDIR /nominatim
RUN curl -O -L http://www.nominatim.org/release/Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && tar xvf Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && mv Nominatim-$NOMINATIM_VERSION Nominatim

# now start over from the same base image
FROM debian:12-slim

ENV DEBIAN_FRONTEND=noninteractive

# install dependencies of the built binaries
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client-15 \
    python3-asyncpg \
    python3-dotenv \
    python3-falcon \
    python3-icu \
    python3-psycopg2 \
    python3-uvicorn \
    python3-sqlalchemy \
    python3-yaml \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# For settings, see: https://nominatim.org/release-docs/develop/customize/Settings/
ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password \
    OSM_FILENAME= \
    WEB_CONCURRENCY=1

WORKDIR /nominatim

# copy the two directories needed
COPY --from=build /nominatim/Nominatim/settings/ /nominatim/settings/
COPY --from=build /nominatim/Nominatim/nominatim/ /nominatim/nominatim/

# copy shell scripts
COPY --chmod=0755 *.sh ./

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "api" ]
