require 'utils'

describe "cron" do
    CONTAINER_INFO_FILE_NAME = "containerInfo.json"

    def delete_container_info_file
        Dir.chdir('src') do
            `rm -f #{CONTAINER_INFO_FILE_NAME}`
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

    def logs
        container_logs @cron_container_name
    end

    before do
        @env_var_value = "value_test_#{rand(100000)}"
        @cron_container_name = "tcn_cron_#{rand(1000000)}"

        delete_container_info_file
    end

    after do
        delete_container_info_file
        delete_container_with_name @cron_container_name
    end

    it "runs the container" do
        Env.create_environment_variable("VAR1", @env_var_value)
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, "VAR1")

        cron %{
            {
                "Image": "ubuntu:latest",
                "Name": "#{@cron_container_name}",
                "Cmd": [
                    "printenv",
                    "VAR1"
                ]
            }
        }

        expect(logs).to include(@env_var_value)
    end
end