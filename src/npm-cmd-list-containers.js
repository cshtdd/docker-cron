var rfr = require("rfr")
var dockerApi = rfr("dockerApi")

console.log("List containers")

dockerApi.list(false, function(err, parts) {
    if (err) {
        throw err
    }

    console.log("RESPONSE")
    console.log(parts)

    console.log("Completed")
})
