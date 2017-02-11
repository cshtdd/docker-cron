var curl = require('curlrequest')

console.log("Run Container", process.argv)

var containerName = ""

if (process.argv.length >= 4){
    containerName = process.argv[2] || ""
    imageConfiguration = process.argv[3] || ""
} else{
    imageConfiguration = process.argv[2] || ""
}

if (!imageConfiguration.length){
    throw new Error("imageConfiguration argument missing")
}

console.log("ImageConfiguration", imageConfiguration)

console.log("Read all containers")

function createContainerWithName(name, containerData){
    console.log("Create container ", name)
    //TODO: put here to make the tests pass. Remove it 
    // console.log(process.env)

    curl.request({
        "unix-socket": "/var/run/docker.sock",
        url: `http:/v1.26/containers/create?name=${name}`,
        method: "POST",
        verbose: true,
        headers: {"Content-Type": "application/json"},
        data: containerData
    }, function(err, parts) {
        if (err) throw err
        // console.log("RESPONSE")
        // console.log(parts)

        var containerInfo = JSON.parse(parts)
        var containerId = containerInfo.Id
        // console.log(containerInfo)
        // console.log(containerId)

        console.log("Starting container ", containerId)

        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.26/containers/${containerId}/start`,
            method: "POST",
            verbose: true,
            headers: {"Content-Type": "application/json"},
            include: true
        }, function(err, parts){
            if (err) throw err;
            console.log("RESPONSE")
            console.log(parts)

            console.log("Completed")
        })
    })
}

curl.request({
    "unix-socket": "/var/run/docker.sock",
    url: 'http:/v1.25/containers/json?all=true',
    verbose: true,
    headers: {"Content-Type": "application/json"}
}, function(err, parts) {
    if (err) throw err;
    // console.log("RESPONSE")
    // console.log(parts)

    var allContainerInfo = JSON.parse(parts)
    // console.log(allContainerInfo)

    var existingContainer = allContainerInfo
        .find((x) => x.Names.find((n) => n == `/${containerName}`))

    if (existingContainer){
        console.log(`Container ${containerName} Already Exist`)

        console.log("Delete Container ", existingContainer.Id)
        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.26/containers/${existingContainer.Id}?force=true`,
            method: "DELETE",
            verbose: true,
            headers: {"Content-Type": "application/json"},
            data: imageConfiguration
        }, function(err, parts){
            if (err) throw err

            createContainerWithName(containerName, imageConfiguration)
        })
    }
    else {
        createContainerWithName(containerName, imageConfiguration)
    }
})
