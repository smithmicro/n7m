#!/bin/bash

set -e

MIRROR_URI=https://download.geofabrik.de

download() {
  DOWNLOAD_FILENAME=$(basename "$1")
  DOWNLOAD_PATH=/data/$DOWNLOAD_FILENAME

  if [ -s ${DOWNLOAD_PATH} ]; then
    echo "OSM file $DOWNLOAD_PATH already exists, skipping download"
  else
    curl -L -o $DOWNLOAD_PATH $1
    if [ $? != 0 ]; then
      echo "Failed to download file $DOWNLOAD_FILENAME"
      exit 1
    fi
  fi
}

help() {
  echo "download [-n|-m|-w|-u|-k|-g|-h] [long options see below]"
  echo "  -f|--africa -          Africa OSM file"
  echo "  -t|--antarctica -      Antarctica OSM file"
  echo "  -a|--asia -            Asia OSM file"
  echo "  -o|--oceania -         Australia and Oceania OSM file"
  echo "  -c|--central-america - Central America OSM file"
  echo "  -e|--europe -          Europe OSM file"
  echo "  -n|--north-america -   North America OSM file"
  echo "  -s|--south-america -   South America OSM file"
  echo "  -m|--monaco -          Monaco OSM File - a small test"
  echo "  -w|--wiki -      Wikimedia file to improve search"
  echo "  -u|--us-postal - US postal code data"
  echo "  -k|--uk-postal - UK postal code data"
  echo "  -g|--grid -      country grids"
  echo "  -h|--help -      this help screen"
}

# Files discussed here:
# https://nominatim.org/release-docs/develop/admin/Import/

while [[ $# -gt 0 ]]; do
  case $1 in
    -f|--africa)
      download $MIRROR_URI/africa-latest.osm.pbf
      shift
      ;;
    -t|--antarctica)
      download $MIRROR_URI/antarctica-latest.osm.pbf
      shift
      ;;
    -a|--asia)
      download $MIRROR_URI/asia-latest.osm.pbf
      shift
      ;;
    -o|--oceania)
      download $MIRROR_URI/australia-oceania-latest.osm.pbf
      shift
      ;;
    -c|--central-america)
      download $MIRROR_URI/central-america-latest.osm.pbf
      shift
      ;;
    -e|--europe)
      download $MIRROR_URI/europe-latest.osm.pbf
      shift
      ;;
    -n|--north-america)
      download $MIRROR_URI/north-america-latest.osm.pbf
      shift
      ;;
    -s|--south-america)
      download $MIRROR_URI/south-america-latest.osm.pbf
      shift
      ;;
    -m|--monaco)
      download $MIRROR_URI/europe/monaco-latest.osm.pbf
      shift
      ;;
    -w|--wiki)
      # improve the quality of search results
      download https://www.nominatim.org/data/wikimedia-importance.sql.gz
      shift
      ;;
    -u|--us-postal)
      # improve postal code search
      download https://www.nominatim.org/data/us_postcodes.csv.gz
      shift
      ;;
    -k|--uk-postal)
      # improve postal code search
      download https://www.nominatim.org/data/gb_postcodes.csv.gz
      shift
      ;;
    -g|--grid)
      # grab country grids
      download https://www.nominatim.org/data/country_grid.sql.gz
      shift
      ;;
    -h|--help)
      help
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      shift
      ;;
  esac
done
