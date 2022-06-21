# =====================================
# Build
# =====================================
FROM node:16 as build

ARG REPO=https://github.com/mainsail-crew/mainsail
ARG BRANCH=master

WORKDIR /srv

# Checkout project
RUN git clone -b ${BRANCH} ${REPO}
WORKDIR mainsail
RUN npm install && \
    ./node_modules/.bin/vue-cli-service build

# =====================================
# Runtime
# =====================================
FROM nginx:alpine as run
COPY --chown=nginx:nginx --from=build /srv/mainsail/dist /usr/share/nginx/html

