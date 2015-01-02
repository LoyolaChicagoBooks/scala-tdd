#!/bin/bash

repo_dir=$1
cd $repo_dir
BEFORE=/tmp/git-before-pull-$$.out
AFTER=/tmp/git-after-pull-$$.out
git log > $BEFORE
git pull > /dev/null
git log > $AFTER
repo_changed=$(diff $BEFORE $AFTER)
rm -f $BEFORE $AFTER
exit $repo_changed
