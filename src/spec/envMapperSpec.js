var rfr = require("rfr")
var envMapper = rfr("envMapper.js")

describe("envMapper", () => {
    it("returns lolo by default", () => {
        expect(envMapper.copy()).toBe("lolo")
    })
})