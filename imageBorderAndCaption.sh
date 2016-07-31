#!/bin/bash

# add white 1px 
convert $1 -bordercolor white -border 1x1 b1.jpg
# add black 
convert b1.jpg -bordercolor black -border 10x10 b2.jpg
convert b2.jpg -gravity South  -background black -splice 0x10 -fill white -annotate +0+2 'Tady je nějaký text' b3.jpg
