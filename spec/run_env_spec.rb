require 'utils'

describe "run" do
    ENV_FILE_NAME = ".env"
    COPY_ENV_VARS_SETTING = "COPY_ENV_VARS"

    def delete_environment_file()
        Dir.chdir('src') do
            `rm -f #{ENV_FILE_NAME}`
            expect(File.file?(ENV_FILE_NAME)).to eq false
        end
    end

    def create_environment_variable(name, value)
        Dir.chdir('src') do
            File.open(ENV_FILE_NAME, 'a') do |file|
                file.write("#{name}=#{value}\n")
            end
            expect(File.file?(ENV_FILE_NAME)).to eq true
        end
    end

    def logs
        container_logs @container_name
    end

    before do
        @container_name = "tcn#{rand(1000000)}"
        delete_environment_file()

        @env_var_name = "RANDOM_VAR"
        @env_var_value = "value_test_#{rand(100000)}"
        create_environment_variable(@env_var_name, @env_var_value)
    end

    after do
        delete_environment_file()
        delete_container_with_name @container_name
    end

    it "propagates variables from the environment file" do
        create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "#{@env_var_name}"
                ]
            }
        }

        sh "rake run[run,#{@container_name},'#{containerInfo}']"

        expect(logs).to include(@env_var_value)
    end

    it "does not propagate variables not specified in #{COPY_ENV_VARS_SETTING}" do
        create_environment_variable("IGNORED_SETTING", "SHOULD_NOT_GET_COPIED")
        create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "IGNORED_SETTING"
                ]
            }
        }

        sh "rake run[run,#{@container_name},'#{containerInfo}']"

        expect(logs).not_to include("SHOULD_NOT_GET_COPIED")
    end

    it "maintains variables from the container definition" do
        create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEMP_VAR1"
                ],
                "Env": [
                    "TEMP_VAR1=EXPECTED_VALUE"
                ]
            }
        }

        sh "rake run[run,#{@container_name},'#{containerInfo}']"

        expect(logs).to include("EXPECTED_VALUE")
    end

    it "does not propagate variables that are not in the environment file" do
        create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEMP_VAR1"
                ]
            }
        }

        sh "rake run[run,#{@container_name},'#{containerInfo}']"

        expect(logs).not_to include("EXPECTED_VALUE")
    end

    it "Does not overwrite variables from the container definition" do
        create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "#{@env_var_name}"
                ],
                "Env": [
                    "#{@env_var_name}=EXPECTED_VALUE"
                ]
            }
        }

        sh "rake run[run,#{@container_name},'#{containerInfo}']"

        expect(logs).to include("EXPECTED_VALUE")
    end
end