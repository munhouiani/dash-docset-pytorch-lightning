#!/usr/bin/env bash
set -euo pipefail

GITHUB_API_URL=${GITHUB_API_URL:-https://api.github.com}

pytorch_lightning_version=$(
  curl -s "${GITHUB_API_URL}/repos/Lightning-AI//releases?per_page=50" |
    jq -r '[.[] | select(.draft == false and .prerelease == false) | select(.tag_name | match("^[0-9]")) | .tag_name][0]'
)

echo "$pytorch_lightning_version"
