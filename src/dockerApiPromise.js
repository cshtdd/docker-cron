var rfr = require("rfr")
var promise = require("the-promise-factory")
var dockerApi = rfr("dockerApi")

module.exports = {
    pullImage: (name) => {
        return promise.create((fulfill, reject) => {
            dockerApi.pullImage(name, (err, data) => {
                if (err){
                    reject(err)
                    return
                }

                fulfill(data)
            })
        })
    }
}
