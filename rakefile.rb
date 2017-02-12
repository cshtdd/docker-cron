task :run, [:task, :arg1, :arg2] do |t, args|
    container_name = ""
    task_args_raw = ""
    env_file_arg = ""
    container_info_file_arg = ""

    if args.to_hash().length >= 3 then
        container_name = args[:arg1] || ""
        task_args_raw = args[:arg2] || ""
    else
        task_args_raw = args[:arg1] || ""
    end

    task_args_cleaned_up = task_args_raw.gsub('"', '\"')
    if task_args_cleaned_up.strip != "" then
        task_args_cleaned_up = "\"#{task_args_cleaned_up}\""
    end

    Dir.chdir('src') do
        ENV_FILE_NAME = ".env"
        CONTAINER_INFO_FILE_NAME = "containerInfo.json"

        if File.file?(ENV_FILE_NAME) then
            env_file_arg = "--env-file #{ENV_FILE_NAME}"
        end

        if File.file?(CONTAINER_INFO_FILE_NAME) then
            container_info_file_arg = "-v #{Dir.pwd}/#{CONTAINER_INFO_FILE_NAME}:/usr/src/containerInfo.json"
        end

        verbose(false) do
            sh %{
                docker run -it --rm --name docker-cron #{env_file_arg}            \
                -v /var/run/docker.sock:/var/run/docker.sock                      \
                -v "#{Dir.pwd}":/usr/src/app -w /usr/src/app                      \
                #{container_info_file_arg}                                        \
                camilin87/docker-cron-api-test                                    \
                npm run --silent                                                  \
                #{args[:task]} #{container_name} #{task_args_cleaned_up}
            }
        end
    end
end

task :build_container do
    Dir.chdir('src') do
        sh "docker build --no-cache -f Dockerfile-api-test -t camilin87/docker-cron-api-test ."

        begin
            File.open(".dockerignore", 'w') do |file|
                ignore_file_lines = [
                    "spec*",
                    "node_modules*",
                    "Dockerfile*"
                ]
                ignore_file_lines.each do |line|
                    file.write("#{line}\n")
                end
            end
            sh "docker build --no-cache -f Dockerfile-docker-cron -t camilin87/docker-cron ." 
        ensure
            `rm -f .dockerignore`
        end
    end
end

task :t => :test
task :test => :tests
task :tests => [:test_unit, :test_int]

task :test_unit do
    Dir.chdir('src') do
        sh "npm t"
    end
end

task :test_int do
    sh "rspec -fd"
end

task :c => :clear
task :clear do
    (`docker ps -a -q` || "").split.each do |id|
        `docker rm -f #{id}`
    end

    `rm -Rf gen_*`
end
