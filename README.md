# Plutus Pioneer Program Docker Setup

This repository aims to semplify and speed up the setup for the Plutus Pioneer Program.
The Dockerfile follows the commands of this [guide](https://docs.google.com/document/d/15QR25eWgg587FTPnuf6Si_lpux-uFQsY_2Gj_4vf4lM/edit) written by **Deceptikon** (thank you for providing it to us).

# Installation

Need Docker installed.

- Create a .env file following the .env.example
- Set GIT_TAG according to the lecture
- Run `chmod +x install_nix.sh`
- Run `docker-compose up -d`
- Run `docker exec -ti plutus-course /bin/bash` and `. /home/$USER/.nix-profile/etc/profile.d/nix.sh` in two terminals
- Run `nix-shell` in the first terminal and wait till it ends. It could take several minutes. Then run the following commands and wait for server to start, it will log "Interpreter ready":
```
cd plutus-playground-client
plutus-playground-server
```

- In the second terminal run again `nix-shell` . This time it will take less than before. Then run:
```
cd plutus-playground-client
npm run start
```
- Wait for the client to start, it will log "webpack compiled with …”
- Now all you have to do is open a web browser and navigate to url https://localhost:8009/ (need to accept that ssl certificate is invalid).


If you can't access to https://localhost:8009/ try add --host 0.0.0.0 to scripts in package.json as follow:
```
...
"scripts": {
    ...
    "build:webpack:dev": "webpack-cli serve --host 0.0.0.0 --progress --inline --hot --mode=development --node-env=development --port=8009",
    ...
},
...
```