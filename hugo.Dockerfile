FROM alpine

RUN apk update && \
    apk add hugo vim git

WORKDIR /home/app/