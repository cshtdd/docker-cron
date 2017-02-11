def delete_container_with_name(container_name)
    `docker rm -f #{container_name}`
    expect(`docker ps`).not_to include(container_name)
end

def container_logs(container_name)
    `docker logs #{container_name}`
end

def build_container_info_arg(container_info_json)
    container_info_json
        .gsub("\n", "")
        .gsub(",", "\\,")
        .strip()
end

def sh(command)
    puts "sh #{command}"
    system(command)
end

def run_nameless_container(container_info)
    sh "rake run[run,'#{build_container_info_arg container_info}']"
end

def run_container_with_name(container_name, container_info)
    sh "rake run[run,#{@container_name},'#{build_container_info_arg container_info}']"
end

class Env
    ENV_FILE_NAME = ".env"

    def self.delete_environment_file()
        Dir.chdir('src') do
            `rm -f #{ENV_FILE_NAME}`
        end
    end

    def self.create_environment_variable(name, value)
        Dir.chdir('src') do
            File.open(ENV_FILE_NAME, 'a') do |file|
                file.write("#{name}=#{value}\n")
            end
        end
    end
end

COPY_ENV_VARS_SETTING = "COPY_ENV_VARS"
