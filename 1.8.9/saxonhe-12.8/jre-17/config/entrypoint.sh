#!/bin/bash
if [ "$1" = "bash" ] || [ "$1" = "sh" ] || [ $# -eq 0 ]; then
    exec /bin/bash
else
    exec Morgana.sh "$@"
fi