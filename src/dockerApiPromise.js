var rfr = require("rfr")
var promise = require("the-promise-factory")
var dockerApi = rfr("dockerApi")

function apiCallback(fulfill, reject){
    return (err, data) => {
        if (err){
            reject(err)
            return
        }

        fulfill(data)
    }
}

module.exports = {
    pullImage: (name) => {
        return promise.create((fulfill, reject) => {
            dockerApi.pullImage(name, apiCallback(fulfill, reject))
        })
    },

    list: (all) => {
        return promise.create((fulfill, reject) => {
            dockerApi.list(all, apiCallback(fulfill, reject))
        })
    },

    create: (name, data) => {
        return promise.create((fulfill, reject) => {
            dockerApi.create(name, data, apiCallback(fulfill, reject))
        })
    },

    start: (containerId) => {
        return promise.create((fulfill, reject) => {
            dockerApi.start(containerId, apiCallback(fulfill, reject))
        })
    },

    delete: (containerId, force) => {
        return promise.create((fulfill, reject) => {
            dockerApi.delete(containerId, force, apiCallback(fulfill, reject))
        })
    }
}
