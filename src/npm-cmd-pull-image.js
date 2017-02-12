var rfr = require("rfr")
var dockerApi = rfr("dockerApiPromise")

console.log("Downloading image")

var imageName = process.argv[2] || ""

dockerApi
    .pullImage(imageName)
    .then(parts => {
        console.log("RESPONSE")
        console.log(parts)
        console.log("Completed")
    }, err => {
        throw err
    })
