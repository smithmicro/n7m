FROM ubuntu:jammy AS build

# https://nominatim.org/release-docs/develop/appendix/Install-on-Ubuntu-22/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    curl \
    git \
    g++ \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-system-dev \
    libbz2-dev \
    libexpat1-dev \
    libicu-dev \
    liblua5.4-dev \
    libpq-dev \
    libproj-dev \
    php \
    php-cgi \
    php-pgsql \
    php-intl \
    postgresql-14-postgis-3 \
    postgresql-14-postgis-3-scripts \
    postgresql-contrib-14 \
    postgresql-server-dev-14 \
    python3-datrie \
    python3-dotenv \
    python3-icu \
    python3-jinja2 \
    python3-psutil \
    python3-psycopg2 \
    python3-yaml \
    zlib1g-dev

ENV NOMINATIM_VERSION=4.2.3

WORKDIR /nominatim

# Build as install
RUN curl -O -L http://www.nominatim.org/release/Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && tar xvf Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && mv Nominatim-$NOMINATIM_VERSION Nominatim

# Build as install
WORKDIR /nominatim/build
RUN cmake ../Nominatim \
 && make \
 && make install

# now start over from the same base image
FROM ubuntu:jammy

# https://nominatim.org/release-docs/4.0.1/develop/Testing/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libproj-dev \
    make \
    phpunit \
    php-cgi \
    php-codecoverage \
    php-pgsql \
    php-xdebug \
    postgresql-client-14 \
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
    python3-yaml \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# copy built binaries
COPY --from=build /nominatim/build  /nominatim/build/
COPY --from=build /nominatim/Nominatim/ /nominatim/

ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password

WORKDIR /nominatim/test

CMD [ "make" ]
