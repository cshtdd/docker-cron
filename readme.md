# Docker-Cron  

Container to run other containers as cron jobs.  

## Usage  

The following command will spawn a container named `testCronAbc` every minute.  
The `testCronAbc` container will print the value of the environment variable `AAA`, `123` in this case.  

```bash
cat > gen_env_file <<EOL
TASK_SCHEDULE=* * * * *
COPY_ENV_VARS=AAA,BBB
AAA=123
BBB=456
EOL

cat > gen_containerInfo.json <<EOL
{
    "Image": "ubuntu:latest",
    "Name": "testCronAbc",
    "Cmd": [
        "printenv",
        "AAA"
    ]
}
EOL

docker run --rm -d --name docker-cron                         \
  -v /var/run/docker.sock:/var/run/docker.sock                \
  -v $PWD/gen_containerInfo.json:/usr/src/containerInfo.json  \
  --env-file gen_env_file                                     \
  camilin87/docker-cron
```


## Configuration  

The cron container behavior can be tweaked with the following environment variables  

    # whether to display verbose logging
    DOCKER_CRON_DEBUG_LOG_ENABLED=1
    # the cron schedule
    TASK_SCHEDULE=* * * * *
    # comma-separated list of the variables
    # that need to be trickled down to the spawned containers
    COPY_ENV_VARS=VAR1,VAR2

## Dev Resources  

[Development Readme](readme-dev.md)

### Useful Links  
- [Container to run Node cron jobs](https://github.com/camilin87/node-cron)  
- [Curl and the Docker Api](https://nathanleclaire.com/blog/2015/11/12/using-curl-and-the-unix-socket-to-talk-to-the-docker-api/)  
- [Docker Engine Api](https://docs.docker.com/engine/api/v1.25/)  
    [Docker 1.12 uses the 1.24 Api version](https://docs.docker.com/engine/api/v1.24/)  
