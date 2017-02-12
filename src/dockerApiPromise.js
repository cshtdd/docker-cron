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
    }
}
