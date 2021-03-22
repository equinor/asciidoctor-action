#!/bin/bash

(
  cd "$(dirname "$0")" || exit 1
  docker build -t asciidoctor-action .
)
echo "${PWD}"

docker run \
    --rm \
    -it \
    -v "${PWD}/dist":/home/pptruser/dist/ \
    -v "${PWD}/docs":/home/pptruser/docs/ \
    asciidoctor-action
