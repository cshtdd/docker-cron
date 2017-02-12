var rfr = require("rfr")
var envMapper = rfr("envMapper")
var dockerApi = rfr("dockerApiPromise")
var createContainerService = rfr("createContainerService")

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

        dockerApi.list(true)
            .then(parts => {
                // console.log("RESPONSE")
                // console.log(parts)

                var allContainerInfo = JSON.parse(parts)
                // console.log(allContainerInfo)

                var existingContainer = allContainerInfo
                    .find((x) => x.Names.find((n) => n == `/${containerName}`))

                if (existingContainer){
                    console.log(`Container ${containerName} Already Exist`)

                    console.log("Delete Container ", existingContainer.Id)
                    dockerApi.delete(existingContainer.Id, true)
                        .then(parts => {
                            createContainerService.exec(containerName, imageConfiguration)
                        }, err => {
                            throw err
                        })
                }
                else {
                    createContainerService.exec(containerName, imageConfiguration)
                }
            }, err => {
                throw err
            })
    }
}