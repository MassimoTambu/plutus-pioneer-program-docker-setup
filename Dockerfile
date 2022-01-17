FROM debian

ARG DOCKER_USER=${DOCKER_USER}
ARG USER_PWD=${USER_PWD}
ARG GIT_TAG=${GIT_TAG}

ENV USER=${DOCKER_USER}
ENV GIT_TAG=${GIT_TAG}

SHELL ["/bin/bash", "-l", "-c"]

COPY ./install_nix.sh /tmp/

# create user
RUN useradd --create-home --shell /bin/bash $DOCKER_USER
RUN echo $DOCKER_USER:$USER_PWD | chpasswd

# install dependencies
RUN apt update && apt install -y curl vim git cabal-install sudo procps net-tools xz-utils man && mandb

RUN adduser $DOCKER_USER sudo

COPY ./run_playground.sh /home/$DOCKER_USER/
RUN chmod +x /home/$DOCKER_USER/run_playground.sh

USER $DOCKER_USER

WORKDIR /home/$DOCKER_USER/
# Install nix and configure cache
RUN bash /tmp/install_nix.sh

# clone plutus-apps and checkout to GIT_TAG
RUN cd && git clone https://github.com/input-output-hk/plutus-apps && \
    cd plutus-apps && git checkout $GIT_TAG

WORKDIR /home/$DOCKER_USER/plutus-apps
RUN sed -i "s/webpack-cli serve/webpack-cli serve --host 0.0.0.0/" plutus-playground-client/package.json
RUN sed -i "s/https: true/https: false/" plutus-playground-client/webpack.config.js
CMD ["bash", "-c", "~/run_playground.sh"]