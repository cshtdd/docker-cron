# Dev  

These are some basic pointers to developers maintaining this project  

## Requirements  
- Docker
- node
- rake
    `gem install rake`
- rspec
    `gem install rspec`

## Building the Container  

    rake build_container

## Tests  

    rake t

## Cleanup  

    rake c

## Running a script in the container  

    # the following command translates to
    #    npm run list
    rake run[list]

    rake run[pull,"node:latest"]
