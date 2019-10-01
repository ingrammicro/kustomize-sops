ARG KUSTOMIZE_VERSION=v3.2.1
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION=1.1.0

FROM golang:1.12-buster as builder
ARG KUSTOMIZE_VERSION

RUN git clone https://github.com/kubernetes-sigs/kustomize.git
RUN echo "replace sigs.k8s.io/kustomize/v3 v3.2.0 => ../../kustomize" >> kustomize/kustomize/go.mod
RUN cd kustomize/kustomize && GO111MODULE=on go build -o /go/bin/kustomize 

FROM debian:buster
ARG KUSTOMIZE_VERSION
ARG KUSTOMIZE_SOPS_PLUGIN_VERSION

LABEL maintainer="imco@ingrammicro.com"

RUN apt update && apt install -y curl git openssh-client  && \
  mkdir -p "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  curl -Lo SopsSecretGenerator https://github.com/goabout/kustomize-sopssecretgenerator/releases/download/v${KUSTOMIZE_SOPS_PLUGIN_VERSION}/SopsSecretGenerator_${KUSTOMIZE_SOPS_PLUGIN_VERSION}_linux_amd64 && \
  chmod +x SopsSecretGenerator && \
  mv SopsSecretGenerator "${XDG_CONFIG_HOME:-$HOME/.config}/kustomize/plugin/goabout.com/v1beta1/sopssecretgenerator" && \
  echo "."
  # The Kustomize release on the GitHub page isn't really v3.2.1, and is therefor missing features we need
  #curl -Lo /usr/bin/kustomize https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_kustomize.${KUSTOMIZE_VERSION}_linux_amd64 && \
  #chmod +x /usr/bin/kustomize

COPY --from=builder /go/bin/kustomize /usr/local/bin/kustomize
COPY /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
