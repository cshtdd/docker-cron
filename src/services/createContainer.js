var rfr = require("rfr")
var logHelper = rfr("utils/logHelper")
var dockerApi = rfr("utils/dockerApiPromise")

module.exports = {
    exec: (name, containerData) => {
        console.log("CreateContainerService", name)

        var containerDataObj = JSON.parse(containerData)
        var imageName = containerDataObj.Image

        console.log("Pulling Image", imageName)

        dockerApi.pullImage(imageName).then(_ => {
            console.log("Create container ", name)

            dockerApi.create(name, containerData).then(parts => {
                if (logHelper.isDebug()) console.log("DEBUG Create.Response=", parts)

                var containerInfo = JSON.parse(parts)
                var containerId = containerInfo.Id

                if (logHelper.isDebug()) {
                    console.log("DEBUG containerInfo=", containerInfo)
                    console.log("DEBUG containerId=", containerId)
                }

                console.log("Starting container ", containerId)

                dockerApi.start(containerId).then(parts => {
                    console.log("RESPONSE")
                    console.log(parts)

                    console.log("Completed")
                }, err => {
                    throw err
                })
            }, err => {
                throw err
            })
        }, err => {
            throw err
        })
    }
}