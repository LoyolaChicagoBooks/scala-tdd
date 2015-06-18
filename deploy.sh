#!/bin/bash

./pull-examples.sh
./sphinx-bootstrap.sh && ./htmlzip.sh && ./pdftk.sh && ./rsync-all.sh
