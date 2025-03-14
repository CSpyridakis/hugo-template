#!/bin/bash

# Useful commands:
# 1. Resize images
#   convert -resize 20% input.png output.png
# 2. Make transparent
#   convert -transparent white input.png output.png
# 3. Convert png -> jpg
#   convert input.png output.png

CNT_RNR="docker"

# Build image
echo "[BUILD IMAGE]"
${CNT_RNR} build -f webp.Dockerfile -t webp .

# Start Container
echo "[START CONTAINER]"
${CNT_RNR} run --rm -it \
    -u "$(id -u):$(id -g)" \
    -v $(pwd)/static/img/:/usr/local/img \
    webp \
   /bin/bash -c "pwd ; find . -type f \\( -iname '*.png' -o -iname '*.jpg' \\) -print0 | while IFS= read -r -d '' file; do cwebp -q 60 \"\$file\" -o \"\${file%.*}.webp\"; done"
