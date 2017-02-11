var rfr = require("rfr")
var envMapper = rfr("envMapper.js")

describe("envMapper", () => {
    it("returns an empty array by default", () => {
        expect(envMapper.copy()).toEqual([])
    })
})