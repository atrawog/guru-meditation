# Use Arch Linux as base image
ARG BASE_IMAGE=archlinux
ARG BASE_VERSION=base-devel
FROM ${BASE_IMAGE}:${BASE_VERSION}

ARG ARCH_BASE=""
ARG ARCH_AI=""
ARG ARCH_EXTRA=""
ARG ARCH_TESTING=""
ARG DOCKER_GID=957

# Install base development tools, sudo, pixi, and other dependencies
RUN groupadd -g $DOCKER_GID docker
RUN pacman -Syu --noconfirm ${ARCH_BASE} && \
    pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm ${ARCH_EXTRA} && \
    pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm ${ARCH_AI} && \
    pacman -Scc --noconfirm
RUN pacman -Syu --noconfirm ${ARCH_TESTING} && \
    pacman -Scc --noconfirm

ARG PIXI_VERSION=v0.40.0   
RUN curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl" \
    -o /usr/local/bin/pixi && chmod +x /usr/local/bin/pixi

ARG USER_NAME=atrawog
ARG USER_UID=1000
ARG USER_GID=1000

ENV USER_NAME=${USER_NAME}
ENV USER_UID=${USER_UID}
ENV USER_GID=${USER_GID}
ENV HOME=/home/${USER_NAME}

RUN groupadd --gid ${USER_GID} ${USER_NAME} && \
    useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USER_NAME} && \
    usermod -aG wheel,docker ${USER_NAME} && \
    echo "%wheel ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/wheel && \
    echo 'Defaults:%wheel !env_reset' | tee -a /etc/sudoers.d/wheel && \
    echo 'Defaults:%wheel env_keep="*"' | tee -a /etc/sudoers.d/wheel && \
    chmod 0440 /etc/sudoers.d/wheel


RUN mkdir -p /{media,sync,workspace} && \
    chown -R ${USER_NAME}:${USER_NAME} /{media,sync,workspace}

COPY config/supervisord.conf /etc/supervisord.conf
COPY config/*.ini /etc/supervisor.d/
COPY config/*.sh /usr/local/bin/

EXPOSE 8888
EXPOSE 8000

USER ${USER_NAME}
WORKDIR ${HOME}

# RUN git clone https://aur.archlinux.org/yay.git && \
#    cd yay && \
#    makepkg -si --noconfirm && \
#    cd .. && rm -rf yay

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/pixi.sh"]