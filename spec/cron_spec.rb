require 'utils'

describe "cron" do
    CONTAINER_INFO_FILE_NAME = "containerInfo.json"

    def delete_container_info_file
        Dir.chdir('src') do
            `rm -f #{CONTAINER_INFO_FILE_NAME}`
        end
    end

    def run(container_info)
        Dir.chdir('src') do
            File.open(CONTAINER_INFO_FILE_NAME, 'w') do |file|
                file.write(container_info)
            end
        end

        sh "rake run[cron]"
    end

    before do
        delete_container_info_file
    end

    after do
        delete_container_info_file
    end

    # generate environment file
    # generate src/.containerInfo.json
    # sh "rake run[cron,'#{build_container_info_arg container_info}']"
    # not sure how to validate the logs

end