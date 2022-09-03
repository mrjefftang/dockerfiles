# =====================================
# Build
# =====================================
FROM node:16-bullseye as build

ARG REPO=https://github.com/eliteSchwein/mooncord
ARG BRANCH=master

WORKDIR /srv

# Checkout project
RUN git clone -b ${BRANCH} ${REPO}
WORKDIR mooncord
RUN npm ci
RUN npm run build

# =====================================
# Runtime
# =====================================
FROM node:16-bullseye as run

VOLUME /data

# Install system dependencies
RUN apt update && \
    apt install -y \
        ffmpeg \
        tini && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m -G tty mooncord

WORKDIR /srv
COPY --chown=mooncord --from=build /srv/mooncord /srv/mooncord

USER mooncord:tty
ENTRYPOINT /tini --
CMD node /srv/mooncord/dist/index.js
