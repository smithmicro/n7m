FROM nginx:1.27-alpine

# https://nominatim.org/release-docs/latest/admin/Setup-Nominatim-UI/

ENV NOMINATIM_UI_VERSION=3.5.3
ENV NOMINATIM_UI_FILENAME=nominatim-ui-$NOMINATIM_UI_VERSION
ENV NOMINATIM_APINOMINATIM_API_ENDPOINT_URI=/api/v4/
ENV NGINX_HTML_PATH=/usr/share/nginx/html

RUN curl -O -L https://github.com/osm-search/nominatim-ui/releases/download/v$NOMINATIM_UI_VERSION/$NOMINATIM_UI_FILENAME.tar.gz \
 && tar xvf $NOMINATIM_UI_FILENAME.tar.gz \
 && mv $NOMINATIM_UI_FILENAME/dist/* $NGINX_HTML_PATH \
 && rm $NOMINATIM_UI_FILENAME.tar.gz \
 && rm -rf $NOMINATIM_UI_FILENAME

RUN echo "Nominatim_Config.Nominatim_API_Endpoint='$NOMINATIM_APINOMINATIM_API_ENDPOINT_URI';" > \
    $NGINX_HTML_PATH/theme/config.theme.js

COPY site.conf /etc/nginx/conf.d/default.conf
