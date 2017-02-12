var curl = require('curlrequest')

module.exports = {
    pullImage: (name, callback) => {
        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.25/images/create?fromImage=${name}`,
            method: "POST",
            verbose: true,
            headers: {"Content-Type": "application/json"},
            include: true
        }, callback)
    },

    list: (all, callback) => {
        var allParam = ""
        if (all){
            allParam = "?all=true"
        }

        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.25/containers/json${allParam}`,
            verbose: true,
            headers: {"Content-Type": "application/json"}
        }, callback)
    },

    create: (name, data, callback) => {
        var nameArg = ""
        if (name){
            nameArg = `name=${name}`
        }

        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.26/containers/create?${nameArg}`,
            method: "POST",
            verbose: true,
            headers: {"Content-Type": "application/json"},
            data: data
        }, callback)
    },

    start: (containerId, callback) => {
        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.26/containers/${containerId}/start`,
            method: "POST",
            verbose: true,
            headers: {"Content-Type": "application/json"},
            include: true
        }, callback)
    },

    delete: (containerId, force, callback) => {
        var forceParam = ""
        if (force){
            forceParam = "force=true"
        }

        curl.request({
            "unix-socket": "/var/run/docker.sock",
            url: `http:/v1.26/containers/${containerId}?${forceParam}`,
            method: "DELETE",
            verbose: true,
            headers: {"Content-Type": "application/json"}
        }, callback)
    }
}