var fs = require("fs");
var rfr = require("rfr")
var logHelper = rfr("utils/logHelper")
var runContainerService = rfr("services/runContainer")

// console.log("Run Cron", process.argv)
console.log("Run Cron")
if (logHelper.isDebug()) console.log("DEBUG argv=", process.argv)


fs.readFile("/usr/src/containerInfo.json", "utf8",  (err, imageConfigurationRaw) => {
    if (err) {
        throw err
    }

    var imageConfigurationObj = JSON.parse(imageConfigurationRaw) || {}
    var containerName = imageConfigurationObj.Name || ""

    runContainerService.exec(containerName, imageConfigurationRaw)
})
