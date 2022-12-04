#! /bin/sh

NAME = Santa-2.5D
SVG = openclipart.org-308933-santa-waving-jb.svg

all:    $(NAME).png $(NAME).3mf

$(NAME).png:    $(NAME).scad $(SVG)
	openscad \
            --colorscheme DeepOcean \
            --imgsize 900,900 \
            --camera 41,50,0,20,0,0,270 \
            -o Santa-2.5D.png \
            Santa-2.5D.scad

$(NAME).3mf:    $(NAME).scad $(SVG)
	openscad \
            -o Santa-2.5D.3mf \
            Santa-2.5D.scad
