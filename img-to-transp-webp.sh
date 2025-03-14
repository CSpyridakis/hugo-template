#!/bin/bash

file_path="${1#static/img/}"
if [ ! -f "./static/img/$file_path" ]; then
  echo "File does not exist. [./static/img/${file_path}]"
  echo "File MUST exist in $(pwd)/static/img/"
  exit 1
fi

CNT_RNR="docker"

# Get from path the img name and folder
img_name=$(basename "$file_path")
img_dir=$(dirname "$file_path")

transp_path="${img_dir}/transparent-${img_name}"
transp_webp=${transp_path%.*}.webp

# 0. Build image that contains needed tools
echo "[BUILD IMAGE]"
${CNT_RNR} build -f webp.Dockerfile -t webp .

# 1. First remove white bg
echo "[REMOVE White bg]"
${CNT_RNR} run --rm -it \
    -u "$(id -u):$(id -g)" \
    -v $(pwd)/static/img/:/usr/local/img \
    webp \
   /bin/bash -c "convert -transparent white ./${file_path} ./${transp_path}"

# 2. Convert to webp
echo "[Convert to webp]"
${CNT_RNR} run --rm -it \
    -u "$(id -u):$(id -g)" \
    -v $(pwd)/static/img/:/usr/local/img \
    webp \
   /bin/bash -c "cwebp -q 60 \"./${transp_path}\" -o \"./${transp_webp}\""

# 3. Display 
# 3.1
echo "===================================================="
echo "A. Use this figure in your posts:"
echo "
{{< figure 
    src=\"/img/${transp_webp}\" 
    alt=\"$(echo ${img_name%.*} | tr '-' ' ' | tr '_' ' ')\" 
    title=\"\" 
    caption=\"\"
    style=\"\" 
    class=\"invert-in-dark\"
>}}
"

# 3.2
echo "===================================================="
echo "B. Use this figure in your posts:"
echo "
<figure class=\"custom-figure\" style=\"margin: 0; padding: 0; text-align: center;\">
  <img src=\"/img/${transp_webp}\" alt=\"$(echo ${img_name%.*} | tr '-' ' ' | tr '_' ' ')\" class=\"invert-in-dark\" style=\"max-width:80%; display: block; margin: 0 auto;\">
    <figcaption class=\"figure-caption\" style=\"margin-top: 0.1em; font-size: 0.85em; color: #555;\">
        TODO (<a href=\"TODO\" style=\"color:inherit\">URL</a>)
    </figcaption>
</figure>
"
