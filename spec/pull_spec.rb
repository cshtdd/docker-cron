require 'utils'

describe "pull" do
    before do
        system("docker rmi alpine:latest") if `docker image ls alpine:latest`.include?("alpine")
        expect(`docker image ls alpine:latest`).not_to include("alpine")
    end

    it "pulls a non-existent image" do
        system('rake run[pull,"alpine"]')
        expect(`docker image ls alpine:latest`).to include("alpine")
    end

    it "pulls an existent image" do
        system('rake run[pull,"alpine"]')
        system('rake run[pull,"alpine"]')

        expect(`docker image ls alpine:latest`).to include("alpine")
    end
end
