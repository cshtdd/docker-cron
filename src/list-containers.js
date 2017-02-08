var curl = require('curlrequest')


console.log("List containers")

curl.request({
    "unix-socket": "/var/run/docker.sock",
    url: 'http:/v1.25/containers/json',
    headers: {"Content-Type": "application/json"},
    include: true
}, function(err, parts) {
    console.log("ERROR", err)
    console.log("RESPONSE")
    console.log(parts)

    console.log("Completed")
})
