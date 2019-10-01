# kustomize-sops
Docker image for Kustomize with Sops Go plugin from https://github.com/Agilicus/kustomize-sops

## Reasoning
To use the Sops Go plugin with Kustomize, Kustomize itself needs to be build at the same time as the plugin.
Instructions on how to do this would get overly complex, which is why we opted to bundle them in a single Docker image.

## Usage

`docker pull ingrammicro/kustomize-sops:v2.0.0`

```docker run ingrammicro/kustomize-sops:v2.0.0 -e AZURE_CLIENT_ID=xxxx -e AZURE_CLIENT_SECRET=xxx -e AZURE_TENANT_ID=xxxx -v KUSTOMIZE_OVERLAY:/kust [-v ~/.ssh/id_rsa:/root/.ssh/id_rsa]```

where:

* KUSTOMIZE_OVERLAY is the path to your overlay directory that contains a kustomization.yaml
* AZURE_CLIENT_ID
* AZURE_CLIENT_SECRET
* AZURE_TENANT_ID

In case you are using a GitHub resource in your overlay that is a private repository, mount your the ssh key that is authorized to access GitHub with -v PATH_TO_ID_RSA_FILE:/root/.ssh/id_rsa

If you are using a full base+overlay dir structure you can use following command:

```docker run ingrammicro/kustomize-sops:v2.0.0 -e AZURE_CLIENT_ID=xxxx -e AZURE_CLIENT_SECRET=xxx -e AZURE_TENANT_ID=xxxx -v KUSTOMIZE_BASE:/kust [-v ~/.ssh/id_rsa:/root/.ssh/id_rsa] KUSTOMIZE_OVERLAY```

where:
* KUSTOMIZE_BASE is the path to your base directory that contains a kustomization.yaml
* KUSTOMIZE_OVERLAY is the path to your overlay directory that contains a kustomization.yaml
