# Docker-Cron  
Container to run other containers as cron jobs  

## Dev Requirements  
- Docker
- rake


## Building the Container  

    rake build_container

## Running the script in the container  

    # the following command translates to
    #    npm run list
    rake run[list]

    rake run[pull,"node:latest"]


## Useful Resources  
- https://nathanleclaire.com/blog/2015/11/12/using-curl-and-the-unix-socket-to-talk-to-the-docker-api/
- https://docs.docker.com/engine/api/v1.25/
