#!/bin/sh

if [ ! -e "/root/.azure/accessTokens.json" ]; then
    echo "ERROR"
    echo "No Azure auth token found"
    echo "Make sure you execute 'az login' in your command line before executing kustomize-sops"
    exit 1
fi

mkdir -p ~/.ssh > /dev/null 2>&1
ssh-keyscan github.com 2>/dev/null >> ~/.ssh/known_hosts

if [ ! -z $1 ]; then
    kustomize build --enable_alpha_plugins /kust/$1
else
    kustomize build --enable_alpha_plugins /kust/
fi
