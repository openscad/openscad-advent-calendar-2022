#! /bin/sh

repeat() {
	CNT="$1"
	BASE="$2"
	for i in "png/$BASE"*
	do
		for n in $(seq 1 "$CNT")
		do
			echo "$i"
		done
	done
}

# Running all in parallel!
./mkvideo.sh block block 4,4 1,1 6 & \
./mkvideo.sh blinker blinker 5,5 1,2 10 & \
./mkvideo.sh glider glider 10,10 0,0 60 & \
./mkvideo.sh rpentomino rpentomino 40,40 19,19 90 & \
./mkvideo.sh gosperglidergun gosperglidergun 50,50 0,0 180

# Debian: sudo apt install webp
img2webp -v -loop 0 -d 50 -lossy -q 30 -m 4 \
	$(repeat 10 block) \
	$(repeat 10 blinker) \
	$(repeat  5 glider) \
	$(repeat  3 rpentomino) \
	$(repeat  2 gosperglidergun) \
	-o Life.webp
