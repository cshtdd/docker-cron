var curl = require('curlrequest')

console.log("Downloading image")

var imageName = process.argv[2] || ""

if (!imageName.length){
    throw new Error("imageName argument missing")
}

console.log("ImageName", imageName)


curl.request({
    "unix-socket": "/var/run/docker.sock",
    url: 'http:/v1.25/images/create?fromImage=' + imageName,
    method: "POST",
    verbose: true,
    headers: {"Content-Type": "application/json"},
    include: true
}, function(err, parts) {
    if (err) throw err;
    console.log("RESPONSE")
    console.log(parts)


    console.log("Completed")
})
