#!/bin/bash

docker build -t asciidoctor-action .

echo "${PWD}"

docker run --rm -it -v "${PWD}/dist":/home/pptruser/dist/ asciidoctor-action
