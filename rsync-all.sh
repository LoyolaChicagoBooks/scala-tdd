#!/bin/bash

echo "Pushing to packt.cs.luc.edu"
rsync -avz --exclude .htaccess \
  $(pwd)/build/ \
  packt.cs.luc.edu:/var/www/vhosts/packt.cs.luc.edu/htdocs/
echo
