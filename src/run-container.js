var curl = require('curlrequest')

console.log("Run Container")

var imageConfiguration = process.argv[2] || ""

if (!imageConfiguration.length){
    throw new Error("imageConfiguration argument missing")
}

console.log("ImageConfiguration", imageConfiguration)


// curl.request({
//     "unix-socket": "/var/run/docker.sock",
//     url: 'http:/v1.25/images/create?fromImage=' + imageConfiguration,
//     method: "POST",
//     headers: {"Content-Type": "application/json"},
//     include: true
// }, function(err, parts) {
//     console.log("ERROR", err)
//     console.log("RESPONSE")
//     console.log(parts)

//     console.log("Completed")
// })
