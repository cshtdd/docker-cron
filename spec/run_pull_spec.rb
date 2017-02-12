require 'utils'

describe "run" do
    before do
        @container_name = "tcn_pull_#{rand(1000000)}"

        sh "docker rmi alpine:latest" if `docker image ls alpine:latest`.include?("alpine")
        expect(`docker image ls alpine:latest`).not_to include("alpine")
    end

    after do
        delete_container_with_name @container_name
    end

    def run(container_info)
        run_container_with_name(@container_name, container_info)
    end

    it "pulls the image before running the container" do
        run %{
            {
                "Image": "alpine",
                "Cmd": "echo test"
            }
        }

        expect(`docker ps -a`).to include(@container_name)
    end
end