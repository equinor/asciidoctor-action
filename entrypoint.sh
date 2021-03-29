#!/bin/bash
set -euo pipefail

shopt -s globstar

if [ "${1:-}" = 'RUN' ]; then

  (
    cd "${3-}"

    readonly destination="/github/workspace/dist"

    for file in ./**/*; do
      [ -e "$file" ] || continue

      # Ignore directories
      [[ -d "$file" ]] && continue
      echo "Processing $PWD/$file"

      case $file in

      *.adoc)
        asciidoctor --failure-level ERROR -r asciidoctor-diagram -D . --backend=html5 -o "$destination/${file%.adoc}".html "${file}"
        ;;
      *.md)
        mkdir -p "$(dirname "$destination/$file")"
        pandoc --from gfm --to html --standalone "$file" -o "$destination/${file%.md}.html"
        ;;
      *.png|*.jpeg|*.html|*.css)
        mkdir -p "$(dirname "$destination/$file")"
        cp "$file" "$destination/$file"
        ;;
      *)
        echo "Unsupported file type $file"
        ;;
      esac

      if [[ "$file" == *"${2%.*-}"* ]]; then
        mv "$destination/${file%.*}.html" "$destination/index.html"
      fi

    done
  )
 
else
  exec "$@"
fi
