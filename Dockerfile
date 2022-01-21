FROM debian

ARG DOCKER_USER=${DOCKER_USER}
ARG USER_PWD=${USER_PWD}
ARG GIT_TAG=${GIT_TAG}

ENV USER=${DOCKER_USER}
ENV GIT_TAG=${GIT_TAG}

SHELL ["/bin/bash", "-l", "-c"]

# install dependencies
RUN apt update
RUN apt install -y curl vim git cabal-install sudo procps net-tools xz-utils man nix-bin
RUN mandb

# configure nix cache
RUN nix-daemon &> /var/log/nix-daemon.log &
RUN echo -e "\
substituters = https://hydra.iohk.io https://iohk.cachix.org https://cache.nixos.org/\n\
trusted-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" >> /etc/nix/nix.conf

# create user
RUN useradd -G sudo,nix-users,nixbld -m -s /bin/bash $DOCKER_USER
RUN echo $DOCKER_USER:$USER_PWD | chpasswd

COPY ./run_playground.sh /home/$DOCKER_USER/
RUN chmod +x /home/$DOCKER_USER/run_playground.sh
RUN mkdir -m 0755 /nix && chown $DOCKER_USER /nix

USER $DOCKER_USER
WORKDIR /home/$DOCKER_USER/

# clone plutus-apps and checkout to GIT_TAG
RUN cd && git clone https://github.com/input-output-hk/plutus-apps && \
    cd plutus-apps && git checkout $GIT_TAG

RUN cabal update

WORKDIR /home/$DOCKER_USER/plutus-apps
RUN sed -i "s/webpack-cli serve/webpack-cli serve --host 0.0.0.0/" plutus-playground-client/package.json
RUN sed -i "s/https: true/https: false/" plutus-playground-client/webpack.config.js
CMD ["bash", "-c", "~/run_playground.sh"]