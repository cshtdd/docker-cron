var rfr = require("rfr")
var envMapper = rfr("envMapper")
var dockerApi = rfr("dockerApi")

module.exports = {
    exec: function(containerName, imageConfigurationRaw){
        if (!imageConfigurationRaw.length){
            throw new Error("imageConfigurationRaw argument missing")
        }

        // console.log("ImageConfigurationRaw", imageConfigurationRaw)

        var imageConfigurationObj = JSON.parse(imageConfigurationRaw)
        imageConfigurationObj.Env = imageConfigurationObj.Env || []
        imageConfigurationObj.Env = envMapper.copy(imageConfigurationObj.Env)
        var imageConfiguration = JSON.stringify(imageConfigurationObj)

        // console.log("ImageConfiguration", imageConfiguration)

        console.log("Read all containers")

        function createContainerWithName(name, containerData){
            console.log("Create container ", name)
            //TODO: put here to make the tests pass. Remove it 
            // console.log(process.env)

            dockerApi.create(name, containerData, function(err, parts) {
                if (err) {
                    throw err
                }
                // console.log("RESPONSE")
                // console.log(parts)

                var containerInfo = JSON.parse(parts)
                var containerId = containerInfo.Id
                // console.log(containerInfo)
                // console.log(containerId)

                console.log("Starting container ", containerId)

                dockerApi.start(containerId, function(err, parts){
                    if (err) throw err;
                    console.log("RESPONSE")
                    console.log(parts)

                    console.log("Completed")
                })
            })
        }

        dockerApi.list(true, function(err, parts) {
            if (err) {
                throw err
            }
            // console.log("RESPONSE")
            // console.log(parts)

            var allContainerInfo = JSON.parse(parts)
            // console.log(allContainerInfo)

            var existingContainer = allContainerInfo
                .find((x) => x.Names.find((n) => n == `/${containerName}`))

            if (existingContainer){
                console.log(`Container ${containerName} Already Exist`)

                console.log("Delete Container ", existingContainer.Id)
                dockerApi.delete(existingContainer.Id, true, function(err, parts){
                    if (err) throw err

                    createContainerWithName(containerName, imageConfiguration)
                })
            }
            else {
                createContainerWithName(containerName, imageConfiguration)
            }
        })
    }
}