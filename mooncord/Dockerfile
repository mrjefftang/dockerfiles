# =====================================
# Build
# =====================================
FROM node:16-bullseye as build

ARG REPO=https://github.com/eliteSchwein/mooncord
ARG BRANCH=master

WORKDIR /srv
RUN apk add --no-cache tini ffmpeg

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

RUN useradd -m -G tty mooncord

WORKDIR /srv
COPY --chown=mooncord --from=build /srv/mooncord ./mooncord

USER mooncord:tty
CMD node /srv/mooncord/dist/index.js
