#!/bin/bash

# Too much args to go through arguments generally
find label_data -name "patch_*" > /tmp/patch.manifest
tar -czf classification_data.tar.gz --files-from=/tmp/patch.manifest

find label_data -name "img_*" > /tmp/attention_network.manifest
tar -czf attention_data.tar.gz --files-from=/tmp/attention_network.manifest
