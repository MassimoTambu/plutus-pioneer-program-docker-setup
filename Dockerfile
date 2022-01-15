FROM ubuntu:20.04

ARG USER=${USER}
ARG USER_PWD=${USER_PWD}
ARG GIT_TAG=${GIT_TAG}

SHELL ["/bin/bash", "-c"]

COPY ./install_nix.sh ./entrypoint.sh /

# install dependencies
RUN apt update && apt install -y curl vim git sudo

# create user
RUN useradd --create-home --shell /bin/bash $USER
RUN echo $USER:$USER_PWD | chpasswd
RUN sudo adduser $USER sudo

USER $USER

# Install nix and configure cache
RUN ./install_nix.sh

# clone plutus-apps and checkout to GIT_TAG
RUN echo $USER_PWD | sudo -S chown -R $USER /mnt && mkdir -p /mnt/course && \
    cd /mnt/course && git clone https://github.com/input-output-hk/plutus-apps && \
    cd plutus-apps && git checkout $GIT_TAG

WORKDIR /mnt/course/plutus-apps
RUN . /home/$USER/.nix-profile/etc/profile.d/nix.sh && nix-build -A plutus-playground.server
