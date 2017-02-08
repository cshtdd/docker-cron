task :run, [:task, :task_args] do |t, args|
    Dir.chdir('src') do
        sh %{
            docker run -it --rm --name docker-cron       \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v "#{Dir.pwd}":/usr/src/app -w /usr/src/app \
            camilin87/docker-cron                        \
            npm run #{args[:task]} #{args[:task_args]}
        }
    end
end


task :build_container do
    Dir.chdir('src') do
      sh "docker build -t camilin87/docker-cron ."
    end
end
