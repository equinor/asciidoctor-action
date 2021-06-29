#!/bin/bash
set -euo pipefail

(
  cd "$(dirname "$0")" || exit 1
  docker build -t asciidoctor-action .
)
echo "${PWD}"

docker run \
    --rm \
    -it \
    -v "${PWD}/dist":/github/workspace/dist/ \
    -v "${PWD}/docs":/home/pptruser/docs/ \
    asciidoctor-action
