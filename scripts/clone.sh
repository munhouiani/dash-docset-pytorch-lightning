#!/usr/bin/env bash
set -euo pipefail

readonly pytorch_lightning_version=$1
readonly dest_dir=$2

function clone {
  local repo=$1
  local tag=$2
  local dir=$3

  if [[ -f $dir/README.md ]]; then
    echo 1>&2 "already cloned: $dir"
    return
  fi

  echo 1>&2 "cloning: $repo@$tag"
  mkdir -p "$dir"
  git clone --depth 1 --branch "$tag" --recurse-submodules -q -c advice.detachedHead=false "$repo" "$dir" &
}

mkdir -p "$dest_dir"

clone https://github.com/Lightning-AI/lightning.git "$pytorch_lightning_version" "$dest_dir"

wait
