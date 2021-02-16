#!/bin/bash
set -euo pipefail

if [ "$1" = 'RUN' ]; then
  convert_to_html () {
      readonly FILE=$(basename "${1}")
      readonly FILENAME="${FILE%.*}"
      asciidoctor -r asciidoctor-diagram -D docs --backend=html5 -o ../dist/"${FILENAME}".html docs/"${FILENAME}".adoc
  }
  export -f convert_to_html
  find ./docs -type f -name '*.adoc' -exec bash -c 'convert_to_html "$0"' {} \;
else
  exec "$@"
fi
