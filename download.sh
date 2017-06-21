#!/bin/bash

echo "Retrieving robot environment"
rsync -l -r rhoban@10.0.0.1:env/* .

