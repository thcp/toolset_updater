#!/bin/bash

set -e

TOOL="aws-vault"
AUTHOR="99designs"
GITHUB_URL="https://api.github.com/repos/${AUTHOR}/${TOOL}/releases/latest"
GIT=$(curl -s $GITHUB_URL)
INSTALLED_VERSION=$( aws-vault --version 2>&1 )
LATEST_VERSION=$(echo "$GIT" | grep -oP '"tag_name": "\K(.*)(?=")' | sed 's/v//g')

URL=$(echo "$GIT" | jq '[.assets[] | select (.browser_download_url | endswith("linux-arm64")) | .browser_download_url ][0]')
RELEASE_URL="https://github.com/${AUTHOR}/${TOOL}/releases/tag/v${LATEST_VERSION}"

INSTALLED_STRIPPED_VERSION=$(echo "$INSTALLED_VERSION" | sed -e 's/v//;s/\.//g')
LATEST_STRIPPED_VERSION=$(echo "$LATEST_VERSION" | sed -e 's/v//;s/\.//g')


if [ "$INSTALLED_STRIPPED_VERSION" -lt "$LATEST_STRIPPED_VERSION" ]; then
  echo "Update required"
  echo "Installed version: $INSTALLED_VERSION "
  echo "Latest version   : v$LATEST_VERSION"
  echo "Release notes    : $RELEASE_URL"
  printf "\n\n"
  cd /tmp
  printf "Downloading from: $URL\n\n"
  curl -L "$URL" -o "$TOOL" && chmod +x "$TOOL"
  sudo mv $TOOL /usr/local/bin
else
  echo "Latest version installed"
fi
