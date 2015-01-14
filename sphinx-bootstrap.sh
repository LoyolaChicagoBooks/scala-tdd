#!/bin/bash

[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

rm -rf build/
make -C source/images/ci
make text
make html
make epub
make LATEXOPTS=' -interaction=batchmode ' latexpdf
