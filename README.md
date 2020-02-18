# kustomize-sops
Docker image for Kustomize with Sops Exec plugin from https://github.com/goabout/kustomize-sopssecretgenerator
This Kustomize-Sops image expects that Sops secrets are encrypted using Azure Key Vaults.

## Contents

* Kustomize v3.5.4
* SopsSecretGenerator v1.2.1

## Requirements

* Docker daemon
* Azure CLI (to authenticate against Azure Key Vault) 

## Sops-secret resource format

__kustomization.yaml__

```yaml
generators:
  - SopsSecretGenerator.yaml
```

__SopsSecretGenerator.yaml__

```yaml
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

`docker pull ingrammicro/kustomize-sops:v3.0.0`

```docker run ingrammicro/kustomize-sops:v3.0.0 -v ~/.azure:/root/.azure -v KUSTOMIZE_OVERLAY:/kust [-v ~/.ssh/id_rsa:/root/.ssh/id_rsa]```

where:

* KUSTOMIZE_OVERLAY is the path to your overlay directory that contains a kustomization.yaml

In case you are using a GitHub resource in your overlay that is a private repository, mount your the ssh key that is authorized to access GitHub with -v PATH_TO_ID_RSA_FILE:/root/.ssh/id_rsa

If you are using a full base+overlay dir structure you can use following command:

```docker run ingrammicro/kustomize-sops:v3.0.0 -v ~/.azure:/root/.azure -v KUSTOMIZE_BASE:/kust [-v ~/.ssh/id_rsa:/root/.ssh/id_rsa] KUSTOMIZE_OVERLAY```

where:

* KUSTOMIZE_BASE is the path to your base directory that contains a kustomization.yaml
* KUSTOMIZE_OVERLAY is the path to your overlay directory that contains a kustomization.yaml
