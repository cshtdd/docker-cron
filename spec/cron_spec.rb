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

    def cron(container_info)
        Dir.chdir('src') do
            File.open(CONTAINER_INFO_FILE_NAME, 'w') do |file|
                file.write(container_info)
            end
        end

        sh "rake run[cron]"
    end

    before do
        @env_var_value = "value_test_#{rand(100000)}"

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

    it "runs the container" do
        Env.create_environment_variable("VAR1", @env_var_value)
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, "VAR1")

        cron %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "VAR1",
                    ">",
                    "/usr/src/app/#{CRON_LOG_FILE_NAME}"
                ]
            }
        }

        Dir.chdir('src') do
            expect(`cat #{CRON_LOG_FILE_NAME}`).to include(@env_var_value)
        end
    end
end