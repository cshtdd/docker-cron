var curl = require('curlrequest')

function apiRequest(data, callback){
    data.verbose = true
    data.headers = {"Content-Type": "application/json"}
    data["unix-socket"] = "/var/run/docker.sock"

    curl.request(data, callback)
}

module.exports = {
    pullImage: (name, callback) => {
        if (!name){
            callback(new Error("imageName argument missing"))
            return
        }

        console.log("ImageName", name)

        apiRequest({
            url: `http:/v1.25/images/create?fromImage=${name}`,
            method: "POST",
            include: true
        }, callback)
    },

    list: (all, callback) => {
        var allParam = ""
        if (all){
            allParam = "?all=true"
        }

        apiRequest({
            url: `http:/v1.25/containers/json${allParam}`
        }, callback)
    },

    create: (name, data, callback) => {
        var nameArg = ""
        if (name){
            nameArg = `name=${name}`
        }

        apiRequest({
            url: `http:/v1.26/containers/create?${nameArg}`,
            method: "POST",
            data: data
        }, callback)
    },

    start: (containerId, callback) => {
        apiRequest({
            url: `http:/v1.26/containers/${containerId}/start`,
            method: "POST",
            include: true
        }, callback)
    },

    delete: (containerId, force, callback) => {
        var forceParam = ""
        if (force){
            forceParam = "force=true"
        }

        apiRequest({
            url: `http:/v1.26/containers/${containerId}?${forceParam}`,
            method: "DELETE"
        }, callback)
    }
}