#!/bin/bash

echo $USER_PWD | sudo -S mkdir -m 0755 /nix
echo $USER_PWD | sudo -S chown $USER /nix

sh <(curl -L https://nixos.org/nix/install) --no-daemon

. /home/$USER/.nix-profile/etc/profile.d/nix.sh

mkdir -p ~/.config/nix
cd ~/.config/nix 

touch nix.conf
tee -a nix.conf > /dev/null <<EOT
substituters = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
experimental-features = nix-command
EOT

echo source ~/.nix-profile/etc/profile.d/nix.sh >> ~/.bashrc
