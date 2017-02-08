# Docker-Cron  
Container to run other containers as cron jobs  

## Building the Container  

    rake build_container

## Running the script in the container  

    docker run -it --rm --name docker-cron \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$PWD":/usr/src/app -w /usr/src/app \
        camilin87/docker-cron \
        npm run list

## Useful Resources  
- https://nathanleclaire.com/blog/2015/11/12/using-curl-and-the-unix-socket-to-talk-to-the-docker-api/
- https://docs.docker.com/engine/api/v1.25/
