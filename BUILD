#!/bin/sh

rm -rf ./public/*

if [ -f /.dockerenv ]; then
    hugo
else
    HUGO_IMG="hugo-template/hugo"

    docker build -t ${HUGO_IMG}:latest -f hugo.Dockerfile . 

    docker run --rm -it \
    -v $(pwd):/home/app \
    -u $(id -u):$(id -g) \
    ${HUGO_IMG}:latest \
    hugo
fi

find public/ -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.pnm" -o -iname "*.ppm" \) -delete