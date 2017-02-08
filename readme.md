# Docker-Cron  
Container to run other containers as cron jobs  


## Running the script in the container  

    docker run -it --rm --name my-running-script \
        -v "$PWD":/usr/src/app -w /usr/src/app node \
        npm start