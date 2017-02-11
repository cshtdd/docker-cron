require 'utils'

describe "Utils.Env" do
    before do
        Env.delete_environment_file
    end

    after do
        Env.delete_environment_file
    end

    it "deletes environment file" do
        Dir.chdir('src') do
            `echo AAAA > .env`
            expect(File.file?(".env")).to eq true
        end

        Env.delete_environment_file

        Dir.chdir('src') do
            expect(File.file?(".env")).to eq false
        end
    end

    it "creates environment variables" do
        Env.create_environment_variable("VAR1", "VALUE1")
        Env.create_environment_variable("VAR2", "VALUE2")

        Dir.chdir('src') do
            expect(File.file?(".env")).to eq true

            expect(`cat .env`).to eq "VAR1=VALUE1\nVAR2=VALUE2\n"
        end
    end
end