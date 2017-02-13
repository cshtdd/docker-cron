require 'utils'

describe "run" do
    before do
        @container_name = "tcn#{rand(1000000)}"
        Env.delete_environment_file()
    end

    after do
        Env.delete_environment_file()
        delete_container_with_name @container_name
    end

    def run(container_info)
        run_container_with_name(@container_name, container_info)
    end

    it "does not log debug logs when the setting is disabled" do
        logs = run %{
            {
                "Image": "alpine",
                "Cmd": [
                    "echo",
                    "test"
                ]
            }
        }

        expect(logs).not_to include("DEBUG Run-Container")
    end

    it "logs debug logs when the setting is enabled" do
        Env.create_environment_variable("DOCKER_CRON_DEBUG_LOG_ENABLED", "1")

        logs = run %{
            {
                "Image": "alpine",
                "Cmd": [
                    "echo",
                    "test"
                ]
            }
        }

        expect(logs).to include("DEBUG Run-Container")
    end
end