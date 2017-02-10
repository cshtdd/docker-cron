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
        delete_environment_file()

        @env_var_name = "RANDOM_VAR"
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