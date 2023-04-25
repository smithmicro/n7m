FROM ubuntu:jammy AS build

# https://nominatim.org/release-docs/develop/appendix/Install-on-Ubuntu-22/
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
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

# Fetch
WORKDIR /nominatim
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

ENV DEBIAN_FRONTEND=noninteractive

# install dependencies of the built binaries
RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    ca-certificates \
    curl \
    libapache2-mod-php \
    libboost-filesystem-dev \
    liblua5.4 \
    libproj-dev \
    php \
    php-cgi \
    php-fpm \
    php-pgsql \
    php-intl \
    postgresql-client-14 \
    python3-datrie \
    python3-dotenv \
    python3-icu \
    python3-jinja2 \
    python3-psutil \
    python3-psycopg2 \
    python3-pyosmium \
    python3-yaml \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# For settings, see: https://nominatim.org/release-docs/develop/customize/Settings/
ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password \
    OSM_FILENAME= \
    FPM_CONFIG=/etc/php/8.1/fpm/pool.d/www.conf

WORKDIR /nominatim

# copy built binaries
COPY --from=build /usr/local/bin/nominatim  /usr/local/bin/
COPY --from=build /usr/local/etc/nominatim/ /usr/local/etc/nominatim/
COPY --from=build /usr/local/lib/nominatim/ /usr/local/lib/nominatim/
COPY --from=build /usr/local/share/nominatim/ /usr/local/share/nominatim/

# copy shell scripts, english only tokenizer.php and Apache config
COPY *.sh ./
COPY tokenizer.php ./tokenizer/
COPY nominatim.conf /etc/apache2/conf-available/

# fpm settings required for Docker
RUN sed -i '1 i\[global]\nerror_log = /proc/self/fd/2\n' $FPM_CONFIG \
 && sed -i 's|;access.log = log/$pool.access.log|access.log = /proc/self/fd/2|' $FPM_CONFIG \
 && sed -i 's|listen = /run/php/php8.1-fpm.sock|listen = 9000|' $FPM_CONFIG

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "fpm" ]

EXPOSE 80 9000
