#!/bin/bash

echo "Pushing to scalaworkshop.cs.luc.edu"
rsync -avz --exclude .htaccess \
  $(pwd)/build/ \
  scalaworkshop.cs.luc.edu:/var/www/vhosts/scalaworkshop.cs.luc.edu/htdocs/
echo
echo "Pushing to introcs.cs.courseclouds.com"
rsync -avz --exclude .htaccess \
  $(pwd)/build/ \
  scalaworkshop.com:./public_html/
echo
