var rfr = require("rfr")
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
                // console.log("RESPONSE")
                // console.log(parts)

                var containerInfo = JSON.parse(parts)
                var containerId = containerInfo.Id
                // console.log(containerInfo)
                // console.log(containerId)

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