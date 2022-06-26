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

ENV DEBIAN_FRONTEND=noninteractive

# install dependencies of the built binaries
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    libapache2-mod-php \
    libproj-dev \
    php \
    php-cgi \
    php-fpm \
    php-pgsql \
    php-intl \
    postgresql-client-13 \
    python3-datrie \
    python3-dotenv \
    python3-icu \
    python3-jinja2 \
    python3-psutil \
    python3-psycopg2 \
    python3-pyosmium \
    python3-yaml

# For settings, see: https://nominatim.org/release-docs/develop/customize/Settings/
ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password \
    OSM_FILENAME=

WORKDIR /nominatim

# copy built binaries
COPY --from=build /usr/local/bin/nominatim  /usr/local/bin/
COPY --from=build /usr/local/etc/nominatim/ /usr/local/etc/nominatim/
COPY --from=build /usr/local/lib/nominatim/ /usr/local/lib/nominatim/
COPY --from=build /usr/local/share/nominatim/ /usr/local/share/nominatim/

# copy shell scripts, english only tokenizer.php and Apache config
COPY *.sh ./
COPY tokenizer.php ./tokenizer/
COPY *.conf /etc/apache2/conf-available/

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "app" ]

EXPOSE 80
