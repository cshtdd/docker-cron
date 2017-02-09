require 'utils'

describe "run" do
    before do
        @container_name = "tcn#{rand(1000000)}"
    end

    after do
        delete_container_with_name @container_name
    end

    it "creates a new container" do
        containerInfo = %{
            {
                "Image": "nginx"
            }
        }
        containerInfoArg = containerInfo.gsub("\n", "").strip()

        system("rake run[run,#{@container_name},'#{containerInfoArg}']")

        expect(`docker ps`).to include(@container_name)
    end

    it "creates an existing one already exists" do
        system("docker run -d --rm --name #{@container_name} nginx")

        containerInfo = %{
            {
                "Image": "nginx"
            }
        }
        containerInfoArg = containerInfo.gsub("\n", "").strip()

        system("rake run[run,#{@container_name},'#{containerInfoArg}']")

        expect(`docker ps`).to include(@container_name)
    end
end
