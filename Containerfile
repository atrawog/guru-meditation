# Use Arch Linux as base image
ARG BASE_IMAGE=archlinux
ARG BASE_VERSION=base-devel
FROM ${BASE_IMAGE}:${BASE_VERSION} AS base

ARG ARCH_BASE=""
ARG ARCH_DEV=""
ARG ARCH_YAY=""
ARG ARCH_CUDA=""
ARG ARCH_CUDNN=""
ARG ARCH_NVIDIA=""
ARG ARCH_OLLAMA=""
ARG DOCKER_GID=957

# Install base development tools, sudo, pixi, and other dependencies

RUN groupadd -g $DOCKER_GID docker
RUN pacman -Syu --noconfirm && \
    pacman -S pacman-contrib --noconfirm && \
    pacman -S --noconfirm ${ARCH_BASE} && \
    paccache -r -k0 && pacman -Scc --noconfirm

RUN pacman -S --noconfirm ${ARCH_DEV} && \
    paccache -r -k0 && pacman -Scc --noconfirm

ARG PIXI_VERSION=v0.43.0 
RUN curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl" \
    -o /usr/local/bin/pixi && chmod +x /usr/local/bin/pixi

ARG USER_NAME=gm
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

RUN mkdir -p /workspace && \
    chown -R ${USER_NAME}:${USER_NAME} /workspace

USER ${USER_NAME}
WORKDIR ${HOME}
ENV MAKEFLAGS="-j$(nproc)"

RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && rm -rf yay

RUN yay -S --noconfirm ${ARCH_YAY} && \
    yay -Scc --noconfirm && \
    yay -Yc --noconfirm

USER root

RUN pacman -S --noconfirm ${ARCH_NVIDIA} && \
    paccache -r -k0 && pacman -Scc --noconfirm

RUN pacman -S --noconfirm ${ARCH_CUDA} && \
    paccache -r -k0 && pacman -Scc --noconfirm
    
RUN pacman -S --noconfirm ${ARCH_CUDNN} && \
    paccache -r -k0 && pacman -Scc --noconfirm

RUN pacman -S --noconfirm ${ARCH_OLLAMA} && \
    paccache -r -k0 && pacman -Scc --noconfirm

COPY config/supervisor/supervisord.conf /etc/supervisord.conf
COPY config/scripts/*.sh /usr/local/bin/

USER ${USER_NAME}
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entry.sh"]

EXPOSE 3000
EXPOSE 8000

FROM base AS devel
USER root
COPY config/supervisor/devel/*.ini /etc/supervisor.d/
EXPOSE 3001
EXPOSE 8011

FROM base
USER root
COPY config/supervisor/prod/*.ini /etc/supervisor.d/
RUN mkdir -p /pixi && chown -R ${USER_NAME}:${USER_NAME} /pixi
RUN mkdir -p /config && chown -R ${USER_NAME}:${USER_NAME} /config

USER ${USER_NAME}
WORKDIR /workspace
ENV JS_CONFIG=/config/jupyterserver.py
ENV JH_CONFIG=/config/jupyterhub.py
ENV JH_PORT=8010
ENV OW_PORT=3000
COPY --chown=${USER_UID}:${USER_GID} pixi/prod /pixi/
COPY --chown=${USER_UID}:${USER_GID} config/jupyter/prod /config/
RUN cd /pixi/jupyter && pixi install -v
RUN cd /pixi/openwebui && pixi install -v

EXPOSE 3000
EXPOSE 8010
