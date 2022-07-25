FROM homeassistant/raspberrypi4-64-homeassistant:stable

# Install avahi-daemon in container
# https://gnanesh.me/avahi-docker-non-root.html
RUN set -ex \
  && apk --no-cache --no-progress add avahi avahi-tools dbus \
  # Disable default Avahi services
  && rm /etc/avahi/services/* \
  && rm -rf /var/cache/apk/*

# Add our custom entrypoint
COPY docker-entrypoint.sh /usr/local/sbin/
ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh"]

