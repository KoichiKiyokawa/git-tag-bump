#! /bin/bash

set -e

function bump() {
  withoutV=${1//v/}
  versions=(${withoutV//./ })
  level=$2
  major=${versions[0]}
  minor=${versions[1]}
  patch=${versions[2]}

  if [ $level = "major" ]; then
    major=$((major + 1))
    minor=0
    patch=0
  elif [ $level = "minor" ]; then
    minor=$((minor + 1))
    patch=0
  elif [ $level = "patch" ]; then
    patch=$((patch + 1))
  fi
  echo "v$major.$minor.$patch"
}

latest_tag=$(gh release list --limit 1 | | awk '{print $1}')
new_tag="$(bump $latest_tag ${1:-patch})"
echo "[INFO] New version is $new_tag"
# git config user.name action
# git config user.email action@users.noreply.github.com
gh release create $new_tag --title $new_tag --target main
