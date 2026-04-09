FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/octokatherine/readme.so.git && \
    cd readme.so && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM --platform=$BUILDPLATFORM node:alpine AS build

WORKDIR /readme.so
COPY --from=base /git/readme.so .
RUN npm ci && \
    npm run build

FROM joseluisq/static-web-server

COPY --from=build /readme.so/out ./public
