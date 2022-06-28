# n7m
Minimalistic Docker images for Nominatim

## About
n7m is a [Numeronym](https://en.wikipedia.org/wiki/Numeronym) for [Nominatim](https://nominatim.org/).

n7m is Nominatim packaged in Docker images with separation of responsibilities between housing the web server, ui, applicaiton server, setup processes, tests and PostgreSQL.

## Overview
This set of Docker images seperates responsbility into 5 areas:
* **n7m-app** - The main Nomainatim service running Apache/PHP connecting to `n7m-gis`
  * **feed** - Uses the `n7m-app` image to set up the `n7m-gis` database.  Can also be used for updates and downloading OSM files.
* **n7m-test** - Runs all unit tests
* **n7m-gis** - Postgis database 
* **n7m-ui** - Test web user interface
* **n7m-web** - nginx web sever that hosts:
  * `n7m-app` @ path: /api/v4/
  * `n7m-ui` @ path: /

## Architecture
```
      |
      v 8080
+--------------+      +--------------+
|              |      |              |
|   n7m-web    |----->|    n7m-ui    |
|              |  80  |              |
+--------------+      +--------------+
|    nginx     |      |    nginx     |
+--------------+      +--------------+
              |        |
              v   80   v
        +--------------+     +--------------+     +--------------+
        |              |     |              |     |              |
        |   n7m-app    |     |   n7m-test   |     |     feed     |
        |              |     |              |     |              |
        +--------------+     +--------------+     +--------------+
        |    debian    |     |    debian    |     |   n7m-app    |
        +--------------+     +--------------+     +--------------+
                      |             |              |        |
                      v     5432    v              v        v
        /--------\    +----------------------------+    /--------\
        | volume |<---|                            |    | volume |
        | pgdata |    |          n7m-gis           |    |  data  |
        \--------/    +                            +    \--------/
                      |----------------------------+ 
                      |      postgis/postgis       |
                      +----------------------------+
```
## To Use
1. Build all the images:
   * `docker-compose build`
2. Download the desired OSM files:
   * To download Monaco, Wikimedia data and country grids:
   * `docker-compose run feed download --monaco --wiki --grid`
3. Edit the OSM_FILENAME environment varianble in `docker-compose.yml` file to select the downloaded OSM file.
   * The default is monaco-latest.osm.pbf
4. Run `docker-compose up`
   * Since the import process is long, the `n7m-app` container terminates after 10 seconds.  Run `docker-compose up` again after import so it restarts.
5. Browse to: `http://localhost:8080`

## Additional Commands
1. To reset the database:
   * `docker-compose run feed reset`
2. To run setup again:
   * `docker-compose run feed setup`
3. To update:
   * `docker-compose run feed update`
3. To run unit tests:
   * `docker-compose run test make`

## Configuration Hints
For updates, consider these configurations:
* NOMINATIM_REPLICATION_MAX_DIFF - you will want to set this to a larger number.
* NOMINATIM_REPLICATION_URL - you will want to set this to a closer mirror.

## Ubuntu vs Debian
`debian:bullseye-slim` was selected as the base image as it is slightly smealler than `ubuntu:focal` and supports PoostgreSQL 13.  Versions that are included below (at the time of this writing):
* `debian:bullseye-slim`
  * 454MB Image for `n7m-app`
  * Python 3.9.2, PHP 7.4.28, psql 13.7
* `ubuntu:focal`
  * 485MB Image for `n7m-app`
  * Python 3.8.10, PHP 7.4.3, psql 12.11
* `debian:bookworm-slim` (not released)
  * 501MB Image for `n7m-app`
  * Python 3.10.5, PHP 8.1.5, psql 14.4
* `ubuntu:jammy`
  * 528MB Image for `n7m-app`
  * Python 3.10.4, PHP 8.1.2, psql 14.3

## Advanced Tokenizer
This image only uses the ICU Tokenizer.  By default the included `tokenizer.php` file drives the PHP code and has a simple English tokenizer.

To have the App use the tokenizer created by the `n7m-feed` container, you can share it into the `n7m-app` container like this in the included `docker-compose.yaml`:
```
  app:
    image: n7m-app
    # ...
    volumes:
      - ${PWD}/data/tokenizer/:/nominatim/tokenizer/    
```
Note: this maps the tokenizer created by `n7m-feed` into the `n7m-app` container.

## AWS EC2
To run n7m in AWS, the minimum EC2 Instance sizing is:
* Instance: `t3.2xlarge` - 32 GB RAM, 8 vCPUs
* Storage: 500GB SSD (270G required for North America)

Note:  At 16 GB RAM, `t3.xlarge` is too small and runs out of memory for osm2pgsql during a North America test.
