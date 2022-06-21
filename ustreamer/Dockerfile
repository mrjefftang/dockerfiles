# =====================================
# Build
# =====================================
FROM ubuntu:focal as build

ARG REPO=https://github.com/pikvm/ustreamer
ARG BRANCH=master

# Install system dependencies
RUN apt update && \
    apt install -y \
        build-essential \
        git \
        libevent-dev \
        libjpeg-dev \
        libbsd-dev && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Checkout project
WORKDIR /srv
RUN git clone -b ${BRANCH} ${REPO}

# Build ustreamer
WORKDIR ustreamer
RUN make

# =====================================
# Runtime
# =====================================
FROM ubuntu:focal as run
EXPOSE 80/tcp

ENV VIDEO_HOST=0.0.0.0
ENV VIDEO_PORT=80
ENV VIDEO_DEV=/dev/video0
ENV VIDEO_FORMAT=YUYV
ENV VIDEO_RES=1280x720
ENV VIDEO_FPS=15
ENV VIDEO_ENCODER=CPU
ENV VIDEO_WORKERS=3
ENV VIDEO_SKIP=30
ENV VIDEO_QUALITY=80

RUN apt update && \
    apt install -y \
        libbsd0 \
        libevent-2.1-7 \
        libevent-pthreads-2.1-7 \
        libjpeg8 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -G video ustreamer
COPY --chown=ustreamer:ustreamer --from=build /srv/ustreamer /srv/ustreamer

USER ustreamer:video
CMD /srv/ustreamer/ustreamer \
        --host=${VIDEO_HOST} \
        --port=${VIDEO_PORT} \
        --device ${VIDEO_DEV} \
        --format=${VIDEO_FORMAT} \
        --resolution ${VIDEO_RES} \
        --desired-fps ${VIDEO_FPS} \
        --quality ${VIDEO_QUALITY}  \
        --encoder=${VIDEO_ENCODER} \
        --workers=${VIDEO_WORKERS} \
        --persistent \
        --drop-same-frames=${VIDEO_SKIP} \
        --slowdown

