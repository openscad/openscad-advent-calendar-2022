#! /bin/sh
set -e

OPENSCAD="/home/jordan/openscad/modref+objects/b/openscad"

usage() {
    echo "Usage: $0 out pattern x,y offsetx,y generations speed" >&2
    exit 1
}

case $# in
6)  ;;
*)
    usage
    ;;
esac

out=$1
pattern=$2
worldSize=$3
offset=$4
generations=$5
speed=$6

rm -f $out*.png

"$OPENSCAD" \
    -o $out.png \
    --imgsize 500,500 \
    --animate $generations \
    --colorscheme DeepOcean \
    -D animate=true \
    -D generations=$generations \
    -D pattern=$pattern \
    -D "worldSize=[$worldSize];" \
    -D "offset=[$offset]" \
    Life.scad

magick convert $out*.png -set delay $speed $out.gif

