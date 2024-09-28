FROM smithmicro/n7m-ui

# required configuration for a Reverse Geocode only UI
RUN echo "Nominatim_Config.Reverse_Only = true;" >> \
    $NGINX_HTML_PATH/theme/config.theme.js \
 && sed -i 's|search.html|reverse.html|' /etc/nginx/conf.d/default.conf
