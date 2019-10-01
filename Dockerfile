ARG KUSTOMIZE_VERSION=v3.2.1
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION=1.1.0

FROM debian:bullseye-slim
ARG KUSTOMIZE_VERSION
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION

LABEL maintainer="imco@ingrammicro.com"

RUN apt update && apt install -y curl git openssh-client  && \
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  curl -Lo SopsSecretGenerator https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${KUSTOMIZE_SOPS_PLUGIN_VERSION}/SopsSecretGenerator_${KUSTOMIZE_SOPS_PLUGIN_VERSION}_linux_amd64 && \
  chmod +x SopsSecretGenerator && \
  mv SopsSecretGenerator "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  curl -Lo /usr/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_kustomize.${KUSTOMIZE_VERSION}_linux_amd64 && \
  chmod +x /usr/bin/kustomize

COPY /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
