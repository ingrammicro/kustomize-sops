# kustomize-sops
Docker image for Kustomize with Sops Go plugin

## Usage

`docker pull ingrammicro/kustomize-sops:v1.0.0`

```docker run ingrammicro/kustomize-sops:v1.0.0 -e AZURE_CLIENT_ID=xxxx -e AZURE_CLIENT_SECRET=xxx -e AZURE_TENANT_ID=xxxx -v KUSTOMIZE_OVERLAY:/kust [-v ~/.ssh/id_rsa:/root/.ssh/id_rsa]```

where:

* KUSTOMIZE_OVERLAY is the path to your overlay directory that contains a kustomization.yaml
* AZURE_CLIENT_ID
* AZURE_CLIENT_SECRET
* AZURE_TENANT_ID

In case you are using a GitHub resource in your overlay that is a private repository, mount your the ssh key that is authorized to access GitHub with -v PATH_TO_ID_RSA_FILE:/root/.ssh/id_rsa
