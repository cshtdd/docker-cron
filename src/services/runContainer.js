var rfr = require("rfr")
var logHelper = rfr("utils/logHelper")
var envMapper = rfr("utils/envMapper")
var dockerApi = rfr("utils/dockerApiPromise")
var createContainerService = rfr("services/createContainer")

module.exports = {
    exec: function(containerName, imageConfigurationRaw){
        if (logHelper.isDebug()) {
            console.log("DEBUG Run-Container")
            console.log("DEBUG ContainerName=", containerName)
            console.log("DEBUG imageConfigurationRaw=", imageConfigurationRaw)
        }

        if (!imageConfigurationRaw.length){
            throw new Error("imageConfigurationRaw argument missing")
        }

        var imageConfigurationObj = JSON.parse(imageConfigurationRaw)
        imageConfigurationObj.Env = imageConfigurationObj.Env || []
        imageConfigurationObj.Env = envMapper.copy(imageConfigurationObj.Env)
        var imageConfiguration = JSON.stringify(imageConfigurationObj)

        if (logHelper.isDebug()) console.log("DEBUG ImageConfiguration=", imageConfiguration)

        console.log("Read all containers")

        dockerApi.list(true).then(parts => {
            var allContainerInfo = JSON.parse(parts)
            if (logHelper.isDebug()) console.log("DEBUG allContainerInfo=", allContainerInfo)

            var existingContainer = allContainerInfo
                .find((x) => x.Names.find((n) => n == `/${containerName}`))

            if (existingContainer){
                console.log(`Container ${containerName} Already Exist`)

                console.log("Delete Container ", existingContainer.Id)
                dockerApi.delete(existingContainer.Id, true).then(parts => {
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