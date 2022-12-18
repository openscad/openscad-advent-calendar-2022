#! /bin/sh

./mkvideo.sh block block 4,4 1,1 6 1x3
./mkvideo.sh blinker blinker 5,5 1,2 10 1x3
./mkvideo.sh glider glider 10,10 0,0 29 1x4
./mkvideo.sh rpentomino rpentomino 40,40 19,19 30 1x7
./mkvideo.sh gosperglidergun gosperglidergun 50,50 0,0 90 1x10

magick convert block.gif blinker.gif glider.gif rpentomino.gif gosperglidergun.gif all.gif

