# n7m
Minimalistic Docker images for Nominatim

## About
n7m is a [Numeronym](https://en.wikipedia.org/wiki/Numeronym) for [Nominatim](https://nominatim.org/).

n7m is Nominatim packaged in Docker images with separation of responsibilities between housing the web server, ui, applicaiton server, setup processes and PostgreSQL.

## Overview
This set of Docker images seperates responsbility into 5 areas:
* **n7m-app** - The main Nomainatim service running PHP-FPM connecting to `n7m-gis`
  * **feed** - Uses the `n7m-app` image to set up the `n7m-gis` database.  Can also be used for updates and downloading files.
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
       |
       v 9000
+--------------+      +--------------+
|              |      |              |
|   n7m-app    |      |     feed     |
|              |      |              |
+--------------+      +--------------+
| ubuntu:jammy |      |   n7m-app    |
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
   * `docker run -v $PWD/data:/tileset openmaptiles/openmaptiles-tools download-osm monaco`
4. Edit the OSM_FILENAME environment varianble in `docker-compose.yml` file to select the downloaded OSM file.
   * The default is `monaco-latest.osm.pbf` which was downloaded in step 3.
5. Run `docker-compose up`
   * Since the import process is long, the `n7m-app` container terminates after 10 seconds.  Run `docker-compose up` again after import so it restarts.
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
For updates, consider these configurations:
* NOMINATIM_REPLICATION_MAX_DIFF - you will want to set this to a larger number.
* NOMINATIM_REPLICATION_URL - you will want to set this to a closer mirror.

## AWS EC2
To run n7m in AWS, the minimum EC2 Instance sizing is:
* Instance: `m5.4xlarge` - 64 GB RAM, 16 vCPUs
* Storage: 350GB SSD for North America

### Instance Comparison
* Instance: `m5.4xlarge` - 64 GB RAM, 16 vCPUs, 0.768/Hour
  * North America:  14.12 hours = $10.84
* Instance: `m5.8xlarge` - 128 GB RAM, 32 vCPUs, 1.536/Hour
  * North America:  10.57 hours = $16.23

## Resources
* [Nominatim Web Site](https://nominatim.org/)
* [Finding places: an introduction to Nominatim](https://www.youtube.com/watch?v=Q4zgDWY8ng0)
* [OpenStreetMap](https://www.openstreetmap.org/about)
* [OpenStreetMap Data Extracts](http://download.geofabrik.de/)
* [Overture Maps Data](https://overturemaps.org/download/)
