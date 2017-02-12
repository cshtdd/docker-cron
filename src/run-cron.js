var fs = require("fs");
var rfr = require("rfr")
var runContainerService = rfr("runContainerService.js")

// console.log("Run Cron", process.argv)
console.log("Run Cron")

fs.readFile("/usr/src/containerInfo.json", "utf8",  (err, imageConfigurationRaw) => {
    // console.log("readFile")
    // console.log(err)
    // console.log(imageConfigurationRaw)

    if (err) throw err;
    runContainerService.exec("", imageConfigurationRaw)
})
