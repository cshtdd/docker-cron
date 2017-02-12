var rfr = require("rfr")
var dockerApi = rfr("dockerApiPromise")

module.exports = {
    exec: (name, containerData) => {
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
    }
}