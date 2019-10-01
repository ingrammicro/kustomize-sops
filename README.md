# kustomize-sops
Docker image for Kustomize with Sops Go plugin from https://github.com/goabout/kustomize-sopssecretgenerator

## Contents
* Kustomize ~~v3.2.1~~ master (temporarily)
* SopsSecretGenerator v1.1.0

## Sops-secret resource format

__kustomization.yaml__
```
generators:
  - SopsSecretGenerator.yaml
```
__SopsSecretGenerator.yaml__
```
apiVersion: goabout.com/v1beta1
kind: SopsSecretGenerator
disableNameSuffixHash: true #default: false
metadata:
  name: my-secret
envs:
  - secret-vars.enc.yaml
files:
  - secret-file.enc.yaml
```
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
