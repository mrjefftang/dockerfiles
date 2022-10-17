# =====================================
# Build
# =====================================
FROM python:3.9 as build

ARG REPO=https://github.com/Arksine/moonraker
ARG BRANCH=master
ARG TIMELAPSE_REPO=https://github.com/mainsail-crew/moonraker-timelapse
ARG TIMELAPSE_BRANCH=main
ARG KLIPPER_REPO=https://github.com/Klipper3d/klipper
ARG KLIPPER_BRANCH=master

WORKDIR /srv

# Checkout project
RUN git clone -b ${BRANCH} ${REPO}
RUN git clone -b ${TIMELAPSE_BRANCH} ${TIMELAPSE_REPO}
RUN git clone -b ${KLIPPER_BRANCH} ${KLIPPER_REPO}
RUN python -m venv venv && \
    venv/bin/pip install -r moonraker/scripts/moonraker-requirements.txt && \
    ln -s /srv/moonraker-timelapse/component/timelapse.py /srv/moonraker/moonraker/components/timelapse.py

# =====================================
# Runtime
# =====================================
FROM python:3.9-slim as run
EXPOSE 7125/tcp
VOLUME /data

ENV MOONRAKER_DIR=/data/moonraker/
ENV MOONRAKER_LOG=/data/moonraker/log
ENV MOONRAKER_DB=/data/moonraker/database
ENV MOONRAKER_CFG=/data/moonraker/moonraker.cfg

# Install system dependencies
RUN apt update && \
    apt install -y \
        curl \
        git \
        ffmpeg \
        iproute2 \
        libcurl4-openssl-dev \
        libgpiod2 \
        libopenjp2-7 \
        liblmdb0 \
        libsodium-dev \
        libssl-dev \
        python3-libgpiod \
        wget \
        zlib1g-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -G dialout,tty moonraker

WORKDIR /srv
COPY --chown=moonraker:moonraker --from=build /srv/moonraker-timelapse ./moonraker-timelapse
COPY --chown=moonraker:moonraker --from=build /srv/moonraker ./moonraker
COPY --chown=moonraker:moonraker --from=build /srv/klipper ./klipper
COPY --chown=moonraker:moonraker --from=build /srv/venv ./venv

USER moonraker:dialout
CMD /srv/venv/bin/python moonraker/moonraker/moonraker.py -c ${MOONRAKER_CFG} -n ${MOONRAKER_DIR} -d ${MOONRAKER_DB} -l ${MOONRAKER_LOG}
