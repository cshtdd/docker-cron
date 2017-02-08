task :run, [:task, :task_args] do |t, args|
    Dir.chdir('src') do

        task_args_raw = args[:task_args]
        task_args_cleaned_up = task_args_raw.gsub('"', '\"')

        # puts "task_args"
        # puts task_args_raw
        # puts task_args_cleaned_up

        sh %{
            docker run -it --rm --name docker-cron       \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "#{Dir.pwd}":/usr/src/app -w /usr/src/app \
            camilin87/docker-cron                        \
            npm run #{args[:task]} "#{task_args_cleaned_up}"
        }
    end
end


task :build_container do
    Dir.chdir('src') do
      sh "docker build -t camilin87/docker-cron ."
    end
end

task :tests do
    Dir.chdir('tests') do
      sh "rake"
    end
end
