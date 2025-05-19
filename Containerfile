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
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -Syu --noconfirm && \
    pacman -S pacman-contrib --noconfirm && \
    pacman -S --noconfirm ${ARCH_BASE}
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -S --noconfirm ${ARCH_DEV}
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
#RUN yay -Syu --noconfirm && \
#    yay -S --noconfirm ${ARCH_YAY} && \
#    yay -Scc --noconfirm && \
#    yay -Yc --noconfirm
USER root
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -S --noconfirm ${ARCH_NVIDIA}
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -S --noconfirm ${ARCH_CUDA}
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -S --noconfirm ${ARCH_CUDNN}
RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    pacman -S --noconfirm ${ARCH_OLLAMA}
ARG PIXI_VERSION=v0.43.0
RUN curl -Ls \
    "https://github.com/prefix-dev/pixi/releases/download/${PIXI_VERSION}/pixi-$(uname -m)-unknown-linux-musl" \
    -o /usr/local/bin/pixi && chmod +x /usr/local/bin/pixi
COPY config/scripts/*.sh /usr/local/bin/
USER ${USER_NAME}
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/entry.sh"]

FROM base AS devel
USER root
# Install Model Context Protocol Inspector
RUN npm install -g @modelcontextprotocol/inspector
COPY config/supervisor/devel/supervisord.conf /etc/supervisord.conf
EXPOSE 3001
EXPOSE 8001
EXPOSE 8011
EXPOSE 8021
EXPOSE 8031
EXPOSE 9100-9110

FROM base
USER root
RUN mkdir -p /pixi && chown -R ${USER_NAME}:${USER_NAME} /pixi
RUN mkdir -p /config && chown -R ${USER_NAME}:${USER_NAME} /config
COPY config/supervisor/prod/supervisord.conf /etc/supervisord.conf
COPY config/supervisor/prod/*.ini /etc/supervisor.d/
USER ${USER_NAME}
WORKDIR /workspace
ENV JS_CONFIG=/config/jupyterserver.py
ENV JH_CONFIG=/config/jupyterhub.py
ENV JH_PORT=8010
ENV JS_PORT=8020
ENV OW_PORT=3000
ENV XDG_CACHE_HOME=/workspace/.cache
COPY --chown=${USER_UID}:${USER_GID} pixi/prod /pixi/
RUN --mount=type=cache,target=/workspace/.cache,uid=${USER_UID},gid=${USER_GID} cd /pixi/openwebui && pixi reinstall -v
RUN --mount=type=cache,target=/workspace/.cache,uid=${USER_UID},gid=${USER_GID} cd /pixi/jupyter && pixi reinstall -v
COPY --chown=${USER_UID}:${USER_GID} config/jupyterserver/prod /config
COPY --chown=${USER_UID}:${USER_GID} config/jupyterhub/prod /config
COPY --chown=${USER_UID}:${USER_GID} config/mcpo/prod /config
EXPOSE 3000
EXPOSE 8000
EXPOSE 8010
EXPOSE 8020
EXPOSE 8030
EXPOSE 9000-9010