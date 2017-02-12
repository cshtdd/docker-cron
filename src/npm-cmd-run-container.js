var rfr = require("rfr")
var runContainerService = rfr("services/runContainer")

// console.log("Run Container", process.argv)
console.log("Run Container")

var containerName = ""
var imageConfigurationRaw = ""

if (process.argv.length >= 4){
    containerName = process.argv[2] || ""
    imageConfigurationRaw = process.argv[3] || ""
} else{
    imageConfigurationRaw = process.argv[2] || ""
}

runContainerService.exec(containerName, imageConfigurationRaw)
