FROM pihole/pihole:latest

EXPOSE 22/tcp

VOLUME /etc/gravity-sync

COPY s6/debian-root /

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt -y install \
        curl \
        git \
        rsync \
        ssh \
        sudo && \
    rm -rf /var/lib/apt/lists/*

RUN curl -sSL http://gravity.vmstan.com/beta | GS_DOCKER=1 bash
