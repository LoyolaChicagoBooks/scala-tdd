#!/bin/bash

if [ -f ~/.env/sphinx/bin/activate ]; then
	. ~/.env/sphinx/bin/activate
fi

python get-examples.py
make -C source/images/ci
make html
make latexpdf
