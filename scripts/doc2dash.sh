#!/usr/bin/env bash
set -euo pipefail

readonly src=$1
readonly dest_dir=$2

doc2dash \
  -n PytorchLightning \
  -I index.html \
  -v -j \
  -u "https://pytorch-lightning.readthedocs.io/en/stable/" \
  -f "$src" \
  -d "$dest_dir"

wait
