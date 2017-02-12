var rfr = require("rfr")
var dockerApi = rfr("dockerApi")


console.log("Downloading image")

var imageName = process.argv[2] || ""

if (!imageName.length){
    throw new Error("imageName argument missing")
}

console.log("ImageName", imageName)

dockerApi.pullImage(imageName, function(err, parts) {
    if (err) throw err;
    console.log("RESPONSE")
    console.log(parts)


    console.log("Completed")
})
