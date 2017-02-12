var fs = require("fs");
var rfr = require("rfr")
var runContainerService = rfr("services/runContainer")

// console.log("Run Cron", process.argv)
console.log("Run Cron")

fs.readFile("/usr/src/containerInfo.json", "utf8",  (err, imageConfigurationRaw) => {
    if (err) {
        throw err
    }

    var imageConfigurationObj = JSON.parse(imageConfigurationRaw) || {}
    var containerName = imageConfigurationObj.Name || ""

    runContainerService.exec(containerName, imageConfigurationRaw)
})
