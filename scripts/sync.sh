#!/bin/bash

YEAR=${YEAR:-$(date +%Y)}
BASE="/home/openscad/www/advent-calendar-${YEAR}"

rsync -rltvP --chmod=D700,F644 index.js $(grep ^setDay index.js | sed -e "s/^.*,\s*dir:\s*'\([^']*\).*$/\1/") openscad@files.openscad.org:"${BASE}"/
