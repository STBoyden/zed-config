#!/usr/bin/env nu

print "Installing bun..."

let bun_install = (curl -fsSL https://bun.sh/install | bash | complete)
if $bun_install.exit_code != 0 {
  print --stderr ($bun_install.stderr | str trim)
  exit $bun_install.exit_code
}

print "\nInstalling fonts..."
nu ./scripts/install-fonts.nu