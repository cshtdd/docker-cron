var rfr = require("rfr")
var envMapper = rfr("envMapper.js")

describe("envMapper", () => {
    it("returns an empty array by default", () => {
        expect(envMapper.copy()).toEqual([])
    })

    it ("returns the unmodified container info env it nothing was copied", () => {
        var containerInfoEnv = [
            "var1=value1",
            "var2=value2"
        ]

        expect(envMapper.copy(containerInfoEnv, {})).toEqual([
            "var1=value1",
            "var2=value2"
        ])
    })

    it ("does not copy variables if COPY_ENV_VARS is missing", () => {
        var processEnv = {
            "var1": "value1",
            "var2": "value2"
        }

        expect(envMapper.copy([], processEnv)).toEqual([])
    })

    it ("does not copy variables not specified to copy", () => {
        var processEnv = {
            "copy": "var5,var6",
            "var1": "value1",
            "var2": "value2"
        }

        expect(envMapper.copy([], processEnv, "copy")).toEqual([])
    })

    it ("does not copy non-existent variables specified to copy", () => {
        var processEnv = {
            "copy": "var5,var6,var1",
            "var1": "value1",
            "var2": "value2"
        }

        expect(envMapper.copy([], processEnv, "copy")).toEqual([
            "var1=value1"
        ])
    })

    it ("copies only those variables explicitely specified to get copied", () => {
        var processEnv = {
            "copy": "var5,var6,var7",
            "var1": "value1",
            "var2": "value2",
            "var5": "value5",
            "var7": "value7"
        }

        expect(envMapper.copy([], processEnv, "copy")).toEqual([
            "var5=value5",
            "var7=value7"
        ])
    })
})