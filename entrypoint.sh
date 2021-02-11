#!/bin/bash
# entrypoint.sh
set -e

export PATH="${PATH}:/root/bin/"

bash -c "$@"
