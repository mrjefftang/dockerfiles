FROM pihole/pihole:latest
HEALTHCHECK NONE

VOLUME /etc/gravity-sync

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt -y install \
        cron \
        curl \
        git \
        rsync \
        sqlite3 \
        ssh \
        sudo && \
    rm -rf /var/lib/apt/lists/*

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN curl -sSL http://gravity.vmstan.com/beta | GS_DOCKER=1 bash

COPY ./docker-entrypoint.sh /

ENTRYPOINT /docker-entrypoint.sh
