#!/bin/sh

if [ -z "$AZURE_CLIENT_ID" ] || [ -z "$AZURE_CLIENT_SECRET" ] || [ -z "$AZURE_TENANT_ID" ]; then
    echo "ERROR"
    echo "Verify whether AZURE_CLIENT_ID, AZURE_CLIENT_SECRET AND AZURE_TENANT_ID variables are correctly set"
    echo "and have permissions to access the Azure Vault used to encrypt the secrets"
    exit 1
fi

mkdir -p ~/.ssh > /dev/null 2>&1
ssh-keyscan github.com 2>/dev/null >> ~/.ssh/known_hosts

if [ ! -z $1 ]; then
    /kustomize build --enable_alpha_plugins /kust/$1
else
    /kustomize build --enable_alpha_plugins /kust/
fi