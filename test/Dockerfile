FROM debian:bullseye-slim AS build

# https://nominatim.org/release-docs/develop/appendix/Install-on-Ubuntu-20/
# Changes from the docs:
# We do not need git
# Other than that, upgraded to PostgreSQL 13 and alphabetized
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    g++ \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libbz2-dev \
    libexpat1-dev \
    libicu-dev \
    libpq-dev \
    libproj-dev \
    php \
    php-cgi \
    php-pgsql \
    php-intl \
    postgresql-13-postgis-3 \
    postgresql-13-postgis-3-scripts \
    postgresql-contrib-13 \
    postgresql-server-dev-13 \
    python3-datrie \
    python3-dotenv \
    python3-icu \
    python3-jinja2 \
    python3-psutil \
    python3-psycopg2 \
    python3-yaml \
    zlib1g-dev

ENV NOMINATIM_VERSION=4.0.1

WORKDIR /nominatim

# Build as install
RUN curl -O -L http://www.nominatim.org/release/Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && tar xvf Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && mkdir build \
 && cd build \
 && cmake ../Nominatim-$NOMINATIM_VERSION \
 && make \
 && make install

# now start over from the same base image
FROM debian:bullseye-slim

# https://nominatim.org/release-docs/4.0.1/develop/Testing/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libproj-dev \
    phpunit \
    php-cgi \
    php-codecoverage \
    php-pgsql \
    php-xdebug \
    postgresql-client-13 \
    python3-behave \
    python3-datrie \
    python3-dotenv \
    python3-icu \
    python3-jinja2 \
    python3-nose \
    python3-psutil \
    python3-psycopg2 \
    python3-pyosmium \
    python3-pytest \
    python3-yaml

ENV NOMINATIM_VERSION=4.0.1

# copy built binaries
COPY --from=build /nominatim/build  /nominatim/build/
COPY --from=build /nominatim/Nominatim-$NOMINATIM_VERSION/ /nominatim/

ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password

WORKDIR /nominatim/test

CMD [ "make" ]
