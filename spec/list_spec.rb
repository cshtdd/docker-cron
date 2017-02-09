require 'utils'

describe "list" do
    before do
        @container_name = "random_container_#{rand(1000000)}"
    end

    after do
        delete_container_with_name @container_name
    end

    it "does not include non-existent containers" do
        expect(`rake run[list]`).not_to include(@container_name)
    end

    it "includes existing containers" do
        system("docker run -d --rm --name #{@container_name} nginx")

        expect(`docker ps`).to include(@container_name)
        expect(`rake run[list]`).to include(@container_name)
    end
end
