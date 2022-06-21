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
RUN npm i -g npm@latest && npm ci --only=prod

# =====================================
# Runtime
# =====================================
FROM node:16-bullseye as run

VOLUME /data

RUN useradd -m -G tty mooncord

WORKDIR /srv
COPY --chown=mooncord --from=build /srv/mooncord ./mooncord

WORKDIR /srv/mooncord
USER mooncord:tty
CMD npm run start /data/mooncord/
