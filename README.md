# n7m
Minimalistic Docker images for Nominatim

## About
n7m is a [Numeronym](https://en.wikipedia.org/wiki/Numeronym) for [Nominatim](https://nominatim.org/).

n7m is Nominatim packaged in Docker images with separation of responsibilities between housing the web server, UI, API server, setup processes and PostGIS.

## Overview
This set of Docker images seperates responsbility into 5 areas:
* **n7m-feed** - The main service for DB creation, updates and downloading files
* **n7m-api** - The API running uvicorn connecting to `n7m-gis`
* **n7m-gis** - PostGIS database 
* **n7m-ui** - Test web user interface
* **n7m-web** - nginx web sever that hosts:
  * `n7m-api` @ path: /api/v4/
  * `n7m-ui` @ path: /

## Architecture
```
       |
       v 8080 (dev), 80 (prod)
+--------------+      +--------------+
|              |      |              |
|   n7m-web    |----->|    n7m-ui    |
|              |  80  |              |
+--------------+      +--------------+
|    nginx     |      |    nginx     |
+--------------+      +--------------+
       |
       v 8000
+--------------+      +--------------+
|              |      |              |
|   n7m-api    |      |   n7m-feed   |
|              |      |              |
+--------------+      +--------------+
|    python    |      |    python    |
+--------------+      +--------------+
               |              |     |
               v      5432    v     v
/--------\   +-----------------+   /--------\
| volume |<--|                 |   | volume |
| pgdata |   |     n7m-gis     |   |  data  |
\--------/   +                 +   \--------/
             |-----------------+
             | postgis/postgis |
             +-----------------+
```
## To Use
1. Build all the images:
   * `docker-compose build`
2. Download Wikimedia data and country grids (optional):
   * `docker-compose run feed download --wiki --grid`
3. Download OSM Data.  We recommend [openmaptiles-tools](https://github.com/openmaptiles/openmaptiles-tools).  For Monaco:
   * `docker run -v <path to working dir>/data:/tileset openmaptiles/openmaptiles-tools download-osm monaco`
4. Edit the OSM_FILENAME environment variable in `docker-compose.yml` file to select the downloaded OSM file.
   * The default is `monaco-latest.osm.pbf` which was downloaded in step 3.
5. Run `docker-compose up`
   * Wait a few minutes for the data to import.  You will see "Import complete"..
6. Browse to: `http://localhost:8080`

## Additional Commands
1. To reset the database:
   * `docker-compose run feed reset`
2. To run setup again:
   * `docker-compose run feed setup`
3. To update once:
   * `docker-compose run feed update`
4. To run replication:
   * `docker-compose run feed replication`

## Configuration Hints
For imports and updates, consider these configurations:
* NOMINATIM_REPLICATION_MAX_DIFF - you will want to set this to a larger number.
* NOMINATIM_REPLICATION_URL - you will want to set this to a closer mirror.
* NOMINATIM_IMPORT_STYLE - Import configuration [`address` | `admin` | `extratags` | `full` | `street`]
* NOMINATIM_IMPORT_FLAGS - additional flags you can pass to `nominatim import`

## Resources
* [Nominatim Web Site](https://nominatim.org/)
* [Finding places: an introduction to Nominatim](https://www.youtube.com/watch?v=Q4zgDWY8ng0)
* [OpenStreetMap](https://www.openstreetmap.org/about)
* [OpenStreetMap Data Extracts](http://download.geofabrik.de/)
