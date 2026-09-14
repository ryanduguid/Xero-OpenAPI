#!/bin/bash
set -euo pipefail

versionNumber=${1:?Version number is required as first argument}
branchName=${2:-master}

git checkout "$branchName"

for file in xero*.yaml; do
    XERO_RELEASE_VERSION="$versionNumber" yq -i '.info.version = strenv(XERO_RELEASE_VERSION)' "$file"
    echo "updated version in $file to $versionNumber"
done

for file in xero*.yaml; do
    XERO_RELEASE_VERSION="$versionNumber" yq -e '.info.version == strenv(XERO_RELEASE_VERSION)' "$file" > /dev/null
done

git add xero*.yaml
git commit -m "chore: bump version to $versionNumber"
git push origin "$branchName"
