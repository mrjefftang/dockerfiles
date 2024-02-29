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

RUN curl -sSL https://raw.githubusercontent.com/vmstan/gs-install/main/gs-install.sh | GS_DOCKER=1 bash
