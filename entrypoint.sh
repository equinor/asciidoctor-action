#!/bin/bash
set -euo pipefail

shopt -s globstar

if [ "${1:-}" = 'RUN' ]; then
  readonly postfix=".adoc"

  (
    cd docs

    for file in ./**/*"$postfix"; do
      [ -e "$file" ] || continue
      echo "$PWD/$file"

      asciidoctor --failure-level ERROR -r asciidoctor-diagram -D . --backend=html5 -o "../dist/${file%$postfix}".html "${file}"
    done
  )

else
  exec "$@"
fi
