var curl = require('curlrequest')


console.log("List containers")

curl.request({
    "unix-socket": "/var/run/docker.sock",
    url: 'http:/v1.25/containers/json',
    verbose: true,
    headers: {"Content-Type": "application/json"},
    include: true
}, function(err, parts) {
    if (err) throw err;
    console.log("RESPONSE")
    console.log(parts)

    console.log("Completed")
})
