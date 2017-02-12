require 'utils'

describe "pull" do
    describe "success" do
        before do
            sh "docker rmi alpine:latest" if `docker image ls alpine:latest`.include?("alpine")
            expect(`docker image ls alpine:latest`).not_to include("alpine")
        end

        it "pulls a non-existent image" do
            sh 'rake run[pull,"alpine"]'
            expect(`docker image ls alpine:latest`).to include("alpine")
        end

        it "pulls an existent image" do
            sh 'rake run[pull,"alpine"]'
            sh 'rake run[pull,"alpine"]'

            expect(`docker image ls alpine:latest`).to include("alpine")
        end
    end

    describe "error" do
        it "fails pulling an unknown image" do
            expect(`rake run[pull,"camilin87/notfound"]`).to include("camilin87/notfound not found")
        end

        it "fails when no image is specified" do
            expect(`rake run[pull]`).to include("Error")
        end
    end
end
