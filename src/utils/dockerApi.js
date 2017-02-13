var rfr = require("rfr")
var logHelper = rfr("utils/logHelper")
var curl = require('curlrequest')

function apiRequest(data, callback){
    data.verbose = true
    data.headers = {"Content-Type": "application/json"}
    data["unix-socket"] = "/var/run/docker.sock"

    curl.request(data, callback)
}

function handleResponse(callback){
    return (err, data) => {
        if (logHelper.isDebug()){
            console.log("DEBUG DockerApi.Response err=", err)
            console.log("DEBUG DockerApi.Response data=", data)
        }
        callback(err, data)
    }
}

module.exports = {
    pullImage: (name, callback) => {
        if (logHelper.isDebug()) console.log("DEBUG DockerApi.pullImage name=", name)

        if (!name){
            callback(new Error("imageName argument missing"))
            return
        }

        console.log("ImageName", name)

        apiRequest({
            url: `http:/v1.25/images/create?fromImage=${name}`,
            method: "POST",
            include: true
        }, handleResponse(callback))
    },

    list: (all, callback) => {
        if (logHelper.isDebug()) console.log("DEBUG DockerApi.list all=", all)

        var allParam = ""
        if (all){
            allParam = "?all=true"
        }

        apiRequest({
            url: `http:/v1.25/containers/json${allParam}`
        }, handleResponse(callback))
    },

    create: (name, data, callback) => {
        if (logHelper.isDebug()) console.log("DEBUG DockerApi.create name=", name, "data=", data)

        var nameArg = ""
        if (name){
            nameArg = `name=${name}`
        }

        apiRequest({
            url: `http:/v1.26/containers/create?${nameArg}`,
            method: "POST",
            data: data
        }, handleResponse(callback))
    },

    start: (containerId, callback) => {
        if (logHelper.isDebug()) console.log("DEBUG DockerApi.start containerId=", containerId)

        apiRequest({
            url: `http:/v1.26/containers/${containerId}/start`,
            method: "POST",
            include: true
        }, handleResponse(callback))
    },

    delete: (containerId, force, callback) => {
        if (logHelper.isDebug()) console.log("DEBUG DockerApi.delete containerId=", containerId)

        var forceParam = ""
        if (force){
            forceParam = "force=true"
        }

        apiRequest({
            url: `http:/v1.26/containers/${containerId}?${forceParam}`,
            method: "DELETE"
        }, handleResponse(callback))
    }
}