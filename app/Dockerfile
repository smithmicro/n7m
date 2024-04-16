FROM ubuntu:jammy AS build

# https://nominatim.org/release-docs/develop/appendix/Install-on-Ubuntu-22/
ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
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
    nlohmann-json3-dev \
    php \
    python3 \
    zlib1g-dev

ENV NOMINATIM_VERSION=4.3.2

# Fetch
WORKDIR /nominatim
RUN curl -O -L http://www.nominatim.org/release/Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && tar xvf Nominatim-$NOMINATIM_VERSION.tar.bz2 \
 && mv Nominatim-$NOMINATIM_VERSION Nominatim

# Build and install
WORKDIR /nominatim/build
RUN cmake ../Nominatim -DBoost_USE_STATIC_LIBS=ON \
 && make \
 && make install

# now start over from the same base image
FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

# install dependencies of the built binaries
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    liblua5.4 \
    libproj-dev \
    postgresql-client-14 \
    python3-asyncpg \
    python3-datrie \
    python3-dotenv \
    python3-falcon \
    python3-geoalchemy2 \
    python3-icu \
    python3-jinja2 \
    python3-psutil \
    python3-psycopg2 \
    python3-pyosmium \
    python3-uvicorn \
    python3-sqlalchemy \
    python3-yaml \
 && rm -rf /var/lib/apt/lists/*

# For settings, see: https://nominatim.org/release-docs/develop/customize/Settings/
ENV NOMINATIM_TOKENIZER=icu \
    PGHOST=gis \
    PGUSER=postgres \
    PGPASSWORD=change-this-password \
    OSM_FILENAME= \
    WEB_CONCURRENCY=1

WORKDIR /nominatim

# copy built binaries
COPY --from=build /usr/local/bin/nominatim  /usr/local/bin/
COPY --from=build /usr/local/etc/nominatim/ /usr/local/etc/nominatim/
COPY --from=build /usr/local/lib/nominatim/ /usr/local/lib/nominatim/
COPY --from=build /usr/local/share/nominatim/ /usr/local/share/nominatim/

# copy shell scripts
COPY --chmod=0755 *.sh ./

ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "app" ]

EXPOSE 8000
