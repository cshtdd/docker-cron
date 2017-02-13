module.exports = {
    isDebug: () => {
        return process.env.DOCKER_CRON_DEBUG_LOG_ENABLED == "1" ? true : false
    }
}