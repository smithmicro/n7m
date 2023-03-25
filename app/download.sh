#!/bin/bash

# download data from www.nominatim.org
# For OSM files, please use:
# https://github.com/openmaptiles/openmaptiles-tools

set -e

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
    -w|--wiki)
      # improve the quality of search results
      download https://www.nominatim.org/data/wikimedia-importance.sql.gz
      shift
      ;;
    -u|--us-postal)
      # improve US postal code search
      download https://www.nominatim.org/data/us_postcodes.csv.gz
      shift
      ;;
    -k|--uk-postal)
      # improve UK postal code search
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
