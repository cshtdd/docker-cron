require 'utils'

describe "run" do
    def logs
        container_logs @container_name
    end

    def run(container_info)
        run_container_with_name(@container_name, container_info)
    end

    before do
        @container_name = "tcn#{rand(1000000)}"
        Env.delete_environment_file()

        @env_var_name = "RANDOM_VAR"
        @env_var_value = "value_test_#{rand(100000)}"
        Env.create_environment_variable(@env_var_name, @env_var_value)
    end

    after do
        Env.delete_environment_file()
        delete_container_with_name @container_name
    end

    it "propagates variables from the environment file" do
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)

        run %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "#{@env_var_name}"
                ]
            }
        }

        expect(logs).to include(@env_var_value)
    end

    it "propagates variables with spaces" do
        Env.create_environment_variable("TEST_VAR1", "this is a multiword value")
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, "#{@env_var_name},TEST_VAR1")

        run %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEST_VAR1"
                ]
            }
        }

        expect(logs).to include("this is a multiword value")
    end

    it "does not propagate variables not specified in #{COPY_ENV_VARS_SETTING}" do
        Env.create_environment_variable("IGNORED_SETTING", "SHOULD_NOT_GET_COPIED")
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)

        run %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "IGNORED_SETTING"
                ]
            }
        }

        expect(logs).not_to include("SHOULD_NOT_GET_COPIED")
    end

    it "maintains variables from the container definition" do
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)

        run %{
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

        expect(logs).to include("EXPECTED_VALUE")
    end

    it "does not propagate variables that are not in the environment file" do
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)

        run %{
            {
                "Image": "ubuntu",
                "Cmd": [
                    "printenv",
                    "TEMP_VAR1"
                ]
            }
        }

        expect(logs).not_to include("EXPECTED_VALUE")
    end

    it "Does not overwrite variables from the container definition" do
        Env.create_environment_variable(COPY_ENV_VARS_SETTING, @env_var_name)

        run %{
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

        expect(logs).to include("EXPECTED_VALUE")
    end
end