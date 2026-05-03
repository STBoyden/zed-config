#!/usr/bin/env bash

echo "Installing bun..."

curl -fsSL https://bun.sh/install | bash

echo -e "\nInitialising git repository in ./zed-ultraViolet..."

(cd ./zed-ultraViolet && git init)

echo -e "\nInstalling fonts..."
./scripts/install-fonts.sh
