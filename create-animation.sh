#!/bin/sh

ffmpeg -framerate 1 -i "output/png/penrose%d.png" output/animation.gif