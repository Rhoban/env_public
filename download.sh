#!/bin/bash

echo "Retrieving robot environment"
rsync --exclude core -l -r rhoban@10.0.0.1:env/* .

echo "Checking git status"
git status

