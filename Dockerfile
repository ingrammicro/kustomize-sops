ARG KUSTOMIZE_VERSION=v3.5.4
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION=1.2.1
ARG AZURE_CLI_VERSION=2.1.0-1~buster

FROM golang:1.13.8-buster as builder
ARG KUSTOMIZE_VERSION

RUN git clone https://github.com/kubernetes-sigs/kustomize.git
RUN cd kustomize/kustomize && GO111MODULE=on go build -o /go/bin/kustomize 

FROM debian:buster
ARG KUSTOMIZE_VERSION
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION
ARG AZURE_CLI_VERSION

LABEL maintainer="imco@ingrammicro.com"

RUN apt update && apt install -y curl git openssh-client python3 python3-distutils gnupg lsb-release apt-transport-https && \
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  curl -Lo SopsSecretGenerator https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${KUSTOMIZE_SOPS_PLUGIN_VERSION}/SopsSecretGenerator_${KUSTOMIZE_SOPS_PLUGIN_VERSION}_linux_amd64 && \
  chmod +x SopsSecretGenerator && \
  mv SopsSecretGenerator "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  echo "Installing Azure CLI $AZURE_CLI_VERSION" && \
  curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null && \
  AZ_REPO=$(lsb_release -cs) && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
  apt update && apt install azure-cli=$AZURE_CLI_VERSION && apt clean && \
  echo "."

COPY --from=builder /go/bin/kustomize /usr/local/bin/kustomize
COPY /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
