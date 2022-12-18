#! /bin/sh
set -e

OPENSCAD=${OPENSCAD:-openscad}

usage() {
    echo "Usage: $0 out pattern x,y offsetx,y generations" >&2
    exit 1
}

case $# in
5)  ;;
*)
    usage
    ;;
esac

out=$1
pattern=$2
worldSize=$3
offset=$4
generations=$5

mkdir -p png
rm -f png/$out*.png

"$OPENSCAD" \
    -o png/$out.png \
    --imgsize 900,900 \
    --animate $generations \
    --colorscheme DeepOcean \
    -D animate=true \
    -D generations=$generations \
    -D pattern=$pattern \
    -D "worldSize=[$worldSize];" \
    -D "offset=[$offset]" \
    Life.scad
