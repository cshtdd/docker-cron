var curl = require('curlrequest')


console.log("Downloading image")

curl.request({
    "unix-socket": "/var/run/docker.sock",
    url: 'http:/v1.25/images/create?fromImage=node:4',
    method: "POST",
    headers: {"Content-Type": "application/json"},
    include: true
}, function(err, parts) {
    console.log("ERROR", err)
    console.log("RESPONSE")
    console.log(parts)

    console.log("Completed")
})
