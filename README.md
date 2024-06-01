> Written with [StackEdit](https:/# Projeto de Containers Spark e Jupyter

Este repositório contém os arquivos necessários para criar containers Docker para:

 - Spark Master (v. 3.5.0)
 - Spark Worker
 - Spark History Server
 - Jupyter Notebook

## Pré-requisitos

- Docker instalado

## Estrutura dos arquivos

- `docker-compose.yaml`: Define os serviços Docker para Spark Master, Spark Workers e Jupyter Notebook.
- `dockerfile-jupyter`: Dockerfile para construir a imagem do Jupyter Notebook.
- `dockerfile-spark`: Dockerfile para construir a imagem do Spark.

## Como usar o Docker Compose

### Subindo os containers

1. Clone o repositório:
    ```bash
    git clone [airtoncarneiro/dev-spark-jupyter](https://github.com/airtoncarneiro/dev-spark-jupyter)
    cd dev-spark-jupyter
    ```

2. Para iniciar os containers com 1 worker, execute:
    ```bash
    docker-compose up -d
    ```

3. Para iniciar os containers com um ou mais workers, utilize a variável de ambiente `WORKERS` para definir o número de workers desejados. Por exemplo, para iniciar com 2 workers:
    ```bash
    docker-compose up -d --scale worker=2
    ```
    *Se não quiser worker: --scale worker=0*

### Acessando as interfaces web

- **Spark Master**:
    - URL: [http://localhost:8080](http://localhost:8080)
    - Interface web do Spark Master para monitoramento do cluster.

- **Jupyter Notebook**:
    - URL: [http://localhost:8888](http://localhost:8888)
    - Interface web do Jupyter Notebook para executar notebooks interativos.

- **Spark History Server**:
    - URL: [http://localhost:18080](http://localhost:18080)
    - Interface web do Spark History Server para visualizar o histórico de execuções de jobs.
    - Os logs são armazenados no diretório `./logs`

## Personalização

Você pode personalizar as configurações dos containers editando os arquivos `docker-compose.yaml`, `dockerfile-jupyter` e `dockerfile-spark` conforme necessário.

## Contribuições

Contribuições são bem vindas! Sinta-se à vontade para sugerir melhorias ou novos ambientes.