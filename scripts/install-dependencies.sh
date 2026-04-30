#!/usr/bin/env bash

echo "Installing bun..."

curl -fsSL https://bun.sh/install | bash

echo "\nInstalling fonts..."
./scripts/install-fonts.sh
