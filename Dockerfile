ARG KUSTOMIZE_VERSION=e0bac6ad192f33d993f11206e24f6cda1d04c4ec
ARG KUSTOMIZE_SOPS_VERSION=4aa4bf3ea4d09635fc652e2542325fef40be2089

# build stage
FROM golang:1.12.7-alpine3.10 AS build-env
ARG KUSTOMIZE_VERSION
ARG KUSTOMIZE_SOPS_VERSION

RUN apk add --update ca-certificates git openssh-client make build-base && \
  mkdir ~/.ssh/ && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  git clone https://github.com/Agilicus/kustomize-sops.git && \
  cd kustomize-sops && \
  #Change protocol to access public repo without need for github account 
  sed -ie 's#git@github.com:#git://github.com/#' Makefile && \
  git checkout ${KUSTOMIZE_SOPS_VERSION} && \
  make

FROM alpine:3.10

LABEL maintainer="imco@ingrammicro.com"

RUN apk add --update ca-certificates git openssh-client && mkdir ~/.config/

COPY --from=build-env /root/bin/kustomize /kustomize
COPY --from=build-env /root/.config/ /root/.config/
COPY /entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]