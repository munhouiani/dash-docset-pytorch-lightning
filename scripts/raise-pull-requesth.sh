#!/usr/bin/env bash
set -euo pipefail

readonly tag="${GITHUB_REF##*/}"
readonly version="${tag#v}"

curl \
    --show-error --fail -i \
    "${GITHUB_API_URL}/repos/Kapeli/Dash-User-Contributions/pulls" \
    -XPOST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: token ${CI_USER_ACCESS_TOKEN}" \
    -H "Content-Type: application/json" \
    -d "
        {
            \"title\": \"update PytorchLightning Doc to version $version\",
            \"head\": \"munhouiani:pytorch-lightning-$tag\",
            \"base\": \"master\",
            \"body\": \"update PytorchLightning Doc to version $version\"
        }
    "
