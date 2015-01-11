#!/bin/bash

[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

rm -rf build/
make text
make html
make epub
make LATEXOPTS=' -interaction=batchmode ' latexpdf
