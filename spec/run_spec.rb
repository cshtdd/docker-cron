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

    it "creates a container when an existing one already exists" do
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

    describe "propagates environment variables" do
        def delete_environment_file()
            `rm -f src/.env`
        end

        def create_environment_variable(name, value)
            
        end

        before do
            delete_environment_file()

            @env_var_name = "random_var"
            @env_var_value = "value_test_#{rand(100000)}"
            create_environment_variable(@env_var_name, @env_var_value)
        end

        after do
            delete_environment_file()
        end

        it "propagates variables from the environment file" do

        end

        it "maintains variables from the container definition" do
        end

        it "does not propagate variables that are not in the environment file" do
        end

        it "overwrites variables from the container definition" do
        end
    end
end
