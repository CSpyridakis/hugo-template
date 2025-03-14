FROM alpine:3.12

ENV WEBP_VERSION=1.1.0-r0

RUN apk update && apk add --no-cache \
    ca-certificates \
    tzdata \
    openssl \
    libwebp-tools \
    bash \
    imagemagick

RUN cwebp -h && dwebp -h && convert -version

WORKDIR /usr/local/img
