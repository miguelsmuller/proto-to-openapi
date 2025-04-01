# Overview

Durante a análise, consideramos diferentes ferramentas para gerar documentação OpenAPI a partir de arquivos `.proto`. Abaixo estão as opções principais:

| Ferramenta                         | Tipo           | OpenAPI | Fornecedor            | Observações                                                                                   |
|-----------------------------------|----------------|---------|------------------------|-----------------------------------------------------------------------------------------------|
| `protoc-gen-openapi`              | Binário (Go)   | v3      | Google / Gnostic       | Simples, direto e mantido pela comunidade. [github.com/google/gnostic](https://github.com/google/gnostic) |
| `protoc-gen-openapiv2`            | Binário (Go)   | v2      | grpc-ecosystem         | Aceita `merge_file_name`, usado pelo `grpc-gateway`. [github.com/grpc-ecosystem](https://github.com/grpc-ecosystem/grpc-gateway) |
| `buf` + `google-gnostic-openapi` | CLI + plugin   | v3      | Buf + comunidade       | Boa integração com CI/CD. Requer `buf.gen.yaml`. [buf.build](https://buf.build)              |
| `namely/docker-protoc`           | Docker         | v2      | Namely                 | Imagem Docker com plugins embutidos. [github.com/namely/docker-protoc](https://github.com/namely/docker-protoc) |


### Todos os .proto tinham option go_package com barra ou ponto
Sim, obrigatório pro plugin protoc-gen-openapi do Gnostic (ele valida isso).
Exemplo válido:

`option go_package = "integration/api/label/v1;labelv1";`

### Usou o binário protoc local
Não dependeu do protoc do sistema nem do Gradle.

### Usou o binário protoc-gen-openapi (do Gnostic) local
É o plugin certo pra gerar OpenAPI v3 com base em descriptor ou .proto.

### Não precisou:
- descriptor_set.desc
- protoc-gen-openapiv2 (do grpc-gateway)


## Para gerar os arquivos OpenAPI:

- Incluímos os diretórios `protos/main` e `template` como `--proto_path`.
- Usamos `protoc-gen-openapi` da Google/Gnostic.
- Indicamos arquivos `.proto` específicos, mais os da pasta de APIs.

### Comando

``` sh
./protoc \
  --proto_path=protos \
  --proto_path=template \
  --plugin=protoc-gen-openapi=./protoc-gen-openapi-v3 \
  --openapi_out=. \
  template/annotations.proto \
  template/template.proto \
  $(find protos/integration/api -name "*.proto")
```
