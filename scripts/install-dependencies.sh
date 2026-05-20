#!/usr/bin/env bash

echo "Installing bun..."

curl -fsSL https://bun.sh/install | bash

echo -e "\nInstalling fonts..."
./scripts/install-fonts.sh
