# Plutus Pioneer Program Docker Setup

This repository aims to semplify and speed up the setup for the Plutus Pioneer Program.
The Dockerfile follows the commands of this [guide](https://docs.google.com/document/d/15QR25eWgg587FTPnuf6Si_lpux-uFQsY_2Gj_4vf4lM/edit) written by **Deceptikon** (thank you for providing it to us).

Thanks to the whole community who helped improve the setup 💯

**Also works on Windows with WSL2 but first nix-shell run requires up to 16GB RAM to complete successfully**

# Installation

Need [Docker](https://www.docker.com/get-started) installed.

- Create a .env file following the .env.example
- Set GIT_TAG according to the lecture
- Run `docker-compose up` . It will takes some time to set up the environment
- You are ready to go!

To enter the container, run `docker exec -it nix-shell`

**Playground**: http://localhost:8009/
<br />
**High level Docs**: http://localhost:8002/
<br />
**Docs for Plutus Libraries**: http://localhost:8002/haddock/
