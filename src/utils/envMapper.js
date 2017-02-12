module.exports = {

    /*
    // the Env field of the container json body
    // an empty array is assumed if nothing is provided
    containerInfoEnv = [
        "VAR1=VALUE1",
        "VAR2=VALUE2"
    ]

    // all the environment variables
    // process.env is assumed if nothing is provided
    processEnv = {
        "COPY_ENV_VARS": "VAR1,VAR2"
        "VAR1": "VALUE1",
        "VAR2": "VALUE2"
    }
    
    // the name of the environment variable that contains the keys to get mapped
    // COPY_ENV_VARS is assumed by default
    // such environment variable will contain a comma separated list of variable names
    copyEnvVarsSetting = "COPY_ENV_VARS"
    */

    copy: (containerInfoEnv, processEnv, copyEnvVarsSetting) => {
        if (!containerInfoEnv){
            containerInfoEnv = []
        }

        if (!processEnv) {
            processEnv = process.env
        }

        if (!copyEnvVarsSetting){
            copyEnvVarsSetting = "COPY_ENV_VARS"
        }

        if (copyEnvVarsSetting in processEnv){
            (processEnv[copyEnvVarsSetting] || "")
                .split(",")
                .map(varName => varName.trim())
                .filter(varName => varName in processEnv)
                .filter(varName => !containerInfoEnv.join(",").includes(`${varName}=`))
                .map(varName => `${varName}=${processEnv[varName]}`)
                .forEach(envVarValue => {
                    containerInfoEnv.push(envVarValue)
                })
        }


        return containerInfoEnv
    }
}