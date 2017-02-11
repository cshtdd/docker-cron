require 'utils'

describe "cron" do
    CONTAINER_INFO_FILE_NAME = "containerInfo.json"
    CRON_LOG_FILE_NAME = "cron.log"

    def delete_container_info_file
        Dir.chdir('src') do
            `rm -f #{CONTAINER_INFO_FILE_NAME}`
        end
    end

    def delete_cron_log
        Dir.chdir('src') do
            `rm -f #{CRON_LOG_FILE_NAME}`
        end
    end

    def run(container_info)
        Dir.chdir('src') do
            File.open(CONTAINER_INFO_FILE_NAME, 'w') do |file|
                file.write(container_info)
            end
        end

        sh "rake run[cron]"
    end

    before do
        delete_container_info_file
        delete_cron_log
    end

    after do
        delete_container_info_file
        delete_cron_log
    end

    # generate environment file
    # generate src/.containerInfo.json
    # sh "rake run[cron,'#{build_container_info_arg container_info}']"
    # not sure how to validate the logs
    #   make the cron container write printenv VAR1 to /usr/src/app/cron.log
    #   validate src/cron.log

end