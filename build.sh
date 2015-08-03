#!/bin/bash

# New all-in-one build script for Introduction to Computer Science in C#

# For Andy, most of your q*.sh scripts are replaced with this one
# e.g. ./build.sh -w builds web version (HTML) only.

# If there is a virtualenv in ~/.env/sphinx (convention used by authors), source it.

[ -f ~/.env/sphinx/bin/activate ] && . ~/.env/sphinx/bin/activate

# build.sh -g
# pulls code examples into source

function git_clone {
   rm -rf examples/*
   git clone https://github.com/LoyolaChicagoCode/integration-scala examples/integration
   git clone https://github.com/LoyolaChicagoCode/lcs-systolicarray-scala examples/lcs-systolicarray
   git clone https://github.com/LoyolaChicagoCode/introcs-scala-examples examples/introcs-scala-examples
   git clone https://github.com/LoyolaChicagoCode/numerical-explorations-scala examples/numerical-explorations-scala
   git clone https://github.com/LoyolaChicagoCode/scala-tdd-fundamentals examples/scala-tdd-fundamentals
}

# build.sh -c
# clean build directory (this will be done prior to any other option)

function clean_build {
   rm -rf build/*
}

# build.sh -w
# builds web version using bootstrap/conf.py

function preconditions {
   make -C source/images/ci
}

function bootstrap_html {
   make CONFIG=bootstrap html
}

# build.sh -e
# builds EPUB version using bootstrap/conf.py

function bootstrap_epub {
   make CONFIG=bootstrap epub
}

# build.sh -p
# builds 8.5 x 11 PDF version using bootstrap/conf.py

function bootstrap_pdf {
   make CONFIG=bootstrap  LATEXOPTS=' -interaction=batchmode ' latexpdf
   rm -rf build/letterpdf
   mv -f build/latex build/letterpdf
}

# build.sh -b
# builds 7 x 9 PDF for CreateSpace (Amazon) using createspace/conf.py

function createspace_pdf {
   make CONFIG=createspace LATEXOPTS=' -interaction=batchmode ' latexpdf
   rm -rf build/bookpdf
   mv -f build/latex build/bookpdf
}

# build.sh -z
# build HTML ZIP bundle (this is for offline reading of HTML)

function htmlzip {
   pushd build
   mkdir -p dist
   rm -rf dist/html.zip
   zip -qr dist/html.zip html/
   popd
}

# build.sh -h or build.sh -?
# shows help

function show_help {
   echo 'build.sh (-h|-?) (-w) (-p) (-e) (-b) (-g) (-i) (-a)'
   echo '  -h or -?: help'
   echo '  -c: clean before building any of the following'
   echo '  -g: pull examples from introcs-csharp-examples, etc.'
   echo '  -w: build HTML (bootstrap config)'
   echo '  -e: build EPUB (bootstrap config)'
   echo '  -p: build PDF (bootstrap config)'
   echo '  -b: build book PDF (createspace config)'
   echo '  -z: build HTML ZIP bundle'
   echo '  -a: all of -g, -w, -e, -p, -b and -z'
}


#
# MAIN
#

HTML=0
EPUB=0
PDF=0
PULL=0
BOOK=0
HTMLZIP=0
CLEAN=0

while getopts "czwepgabh?i" opt; do
    case "$opt" in
    a)  HTML=1; EPUB=1; PDF=1; BOOK=1; PULL=1; HTMLZIP=1
        ;;
    c)  CLEAN=1
        ;;
    w)  HTML=1
        ;;
    e)  EPUB=1
        ;;
    p)  PDF=1
        ;;
    b)  BOOK=1
        ;;
    g)  PULL=1
        ;;
    z)  HTML=1; HTMLZIP=1
        ;;
    h|\?)
        show_help
        exit 0
        ;;
    esac
done

preconditions
[ $CLEAN -ne 0 ] && clean_build
[ $PULL -ne 0 ] && git_clone
[ $HTML -ne 0 ] && bootstrap_html
[ $EPUB -ne 0 ] && bootstrap_epub
[ $PDF -ne 0 ] && bootstrap_pdf
[ $BOOK -ne 0 ] && createspace_pdf
[ $HTMLZIP -ne 0 ] && htmlzip
