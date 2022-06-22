# =====================================
# Build
# =====================================
FROM node:16-alpine as build

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
FROM node:16-alpine as run

VOLUME /data

RUN useradd -m -G tty mooncord

RUN apk add --no-cache tini ffmpeg

WORKDIR /srv
COPY --chown=mooncord --from=build /srv/mooncord ./mooncord

USER mooncord:tty
ENTRYPOINT /tini --
CMD node /srv/mooncord/dist/index.js
