# Docker-Cron  
Container to run other containers as cron jobs  

## Usage  

TODO: finish this up

### Environment variables  

    DOCKER_CRON_DEBUG_LOG_ENABLED=1

## Dev  

### Requirements  
- Docker
- node
- rake
    `gem install rake`
- rspec
    `gem install rspec`

### Building the Container  

    rake build_container

### Running the script in the container  

    # the following command translates to
    #    npm run list
    rake run[list]

    rake run[pull,"node:latest"]


## Useful Resources  
- https://nathanleclaire.com/blog/2015/11/12/using-curl-and-the-unix-socket-to-talk-to-the-docker-api/
- https://docs.docker.com/engine/api/v1.25/
