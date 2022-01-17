#!/bin/bash

. /home/$USER/.nix-profile/etc/profile.d/nix.sh && nix-build -A plutus-playground.client
nix-shell --run "cabal update"
nix-shell --run "cd plutus-playground-client && plutus-playground-server &" 
nix-shell --run "build-and-serve-docs &" 
nix-shell --command "cd plutus-playground-client && npm start"