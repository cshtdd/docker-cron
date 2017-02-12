var rfr = require("rfr")
var dockerApi = rfr("utils/dockerApiPromise")

console.log("List containers")

dockerApi.list(false).then(parts => {
    console.log("RESPONSE")
    console.log(parts)

    console.log("Completed")
}, err => {
    throw err
})
