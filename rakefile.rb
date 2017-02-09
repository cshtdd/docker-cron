task :run, [:task, :arg1, :arg2] do |t, args|
    container_name = ""
    task_args_raw = ""

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
        sh %{
            docker run -it --rm --name docker-cron       \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "#{Dir.pwd}":/usr/src/app -w /usr/src/app \
            camilin87/docker-cron-api-test               \
            npm run #{args[:task]} #{container_name} #{task_args_cleaned_up}
        }
    end
end

task :build_container do
    Dir.chdir('src') do
      sh "docker build -f Dockerfile-api-test -t camilin87/docker-cron-api-test ."
    end
end

task :t => :test
task :test => :tests
task :tests do
    sh "rspec -fd"
end
