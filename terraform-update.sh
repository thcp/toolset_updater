#!/bin/bash


set -e

HTOOL="terraform"
GITHUB_URL="https://api.github.com/repos/hashicorp/${HTOOL}/releases/latest"
INSTALLED_VERSION=$(terraform -v | awk '{print $2}'| head -1)
LATEST_VERSION=$(curl -s $GITHUB_URL | grep -oP '"tag_name": "\K(.*)(?=")'  | sed 's/v//g')
URL="https://releases.hashicorp.com/${HTOOL}/${LATEST_VERSION}/${HTOOL}_${LATEST_VERSION}_linux_amd64.zip"
RELEASE_URL="https://github.com/hashicorp/${HTOOL}/releases/tag/v${LATEST_VERSION}"


INSTALLED_STRIPPED_VERSION=$(echo $INSTALLED_VERSION| sed -e 's/v//;s/\.//g')
LATEST_STRIPPED_VERSION=$(echo $LATEST_VERSION | sed -e 's/v//;s/\.//g')

if [ "$INSTALLED_STRIPPED_VERSION" -lt "$LATEST_STRIPPED_VERSION" ]; then
  echo "Update required"
  echo "Installed version: $INSTALLED_VERSION "
  echo "Latest version   : v$LATEST_VERSION"
  echo "Release notes    : $RELEASE_URL"
  printf "\n\n"
  cd /tmp
  printf "Downloading from: $URL\n\n"
  curl -L $URL -o "$HTOOL".zip | xargs unzip -o $HTOOL
  sudo mv $HTOOL /usr/local/bin
else
  echo "Latest version installed"
fi
