#!/bin/bash
export TZ=UTC

YEAR=${YEAR:-$(date +%Y)}
MONTH=${MONTH:-$(date +%m)}
DAY=${DAY:-$(date +setDay.%-d,)}
LOG=${LOG:-/home/openscad/advent-calendar.log}
BASE="/home/openscad/www/advent-calendar-${YEAR}"
INDEX="${BASE}/index.js"

if [ ! -f "${INDEX}" ]; then
	echo "$(date): Skipping, index file does not exist: '${INDEX}'" >> "$LOG"
	exit 0
fi

if [ "${MONTH}" -ne 12 ]; then
	echo "$(date): Skipping, month = ${MONTH}" >> "${LOG}"
	exit 0
fi

sleep 2
DIR=$(grep "${DAY}" "${INDEX}" | sed -e "s/^.*,\s*dir:\s*'\([^']*\).*$/\1/")
echo "$(date): Directory: '$DIR'" >> "${LOG}"
if [ -n "$DIR" ]; then
	chmod -v -f 755 "${BASE}/${DIR}" >> "${LOG}"
fi
