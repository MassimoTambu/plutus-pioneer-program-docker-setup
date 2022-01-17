#!/bin/bash

nix-build -A plutus-playground.client
nix-shell --run "cd plutus-playground-client && plutus-playground-server &"
nix-shell --run "build-and-serve-docs &"
nix-shell --command "cd plutus-playground-client && npm start"
