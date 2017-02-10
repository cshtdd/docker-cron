require 'utils'

describe "run propagates environment variables" do
    ENV_FILE_NAME = ".env"

    def delete_environment_file()
        Dir.chdir('src') do
            `rm -f #{ENV_FILE_NAME}`
            expect(File.file?(ENV_FILE_NAME)).to eq false
        end
    end

    def create_environment_variable(name, value)
        Dir.chdir('src') do
            File.open(ENV_FILE_NAME, 'w') do |file|
                file.write("#{name}=#{value}")
            end
            expect(File.file?(ENV_FILE_NAME)).to eq true
        end
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
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "#{@env_var_name}"
                ]
            }
        }
        expect(`rake run[run,#{@container_name},'#{containerInfo}']`).to include(@env_var_value)
    end

    it "maintains variables from the container definition" do
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
        expect(`rake run[run,#{@container_name},'#{containerInfo}']`).to include("EXPECTED_VALUE")
    end

    it "does not propagate variables that are not in the environment file" do
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEMP_VAR1"
                ]
            }
        }
        expect(`rake run[run,#{@container_name},'#{containerInfo}']`).not_to include("EXPECTED_VALUE")
    end

    it "Does not overwrite variables from the container definition" do
        containerInfo = build_container_info_arg %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEMP_VAR1"
                ],
                "Env": [
                    "#{@env_var_name}=EXPECTED_VALUE"
                ]
            }
        }
        expect(`rake run[run,#{@container_name},'#{containerInfo}']`).to include("EXPECTED_VALUE")
    end
end