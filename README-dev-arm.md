# ARM build instructions  

## Clone the repo  

```bash
git clone https://github.com/camilin87/docker-cron.git
```

## Get the latest source  

```bash
git pull --rebase
```

## Login to the Docker registry  

```bash
docker login
```

## Build the image  

```bash
pushd src
docker build -f Dockerfile-docker-cron-arm32v6 -t camilin87/docker-cron-arm32v6 .
popd
```

## Publish the image  

```bash
docker push camilin87/docker-cron-arm32v6
```

## Cleanup  

```bash
docker rmi camilin87/docker-cron-arm32v6
docker system prune -f
```
