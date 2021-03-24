#!/bin/bash
set -euo pipefail

shopt -s globstar

if [ "${1:-}" = 'RUN' ]; then

  (
    cd docs

    readonly destination="../dist"

    for file in ./**/*; do
      [ -e "$file" ] || continue

      # Ignore directories
      [[ -d "$file" ]] && continue
      echo "Processing $PWD/$file"

      echo "File name is: $file"
      echo "2nd parameter is: ${2-}"
      echo "1st parameter is: ${1:-}"

      if [[ "$file" == *"${2-}"* ]]; then
        ls -l whoami
        mv "$file" "index.${file##*.}"
        echo "Inside if statement with parameter: ${2-}"
      fi

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
    done
  )
 
else
  exec "$@"
fi
