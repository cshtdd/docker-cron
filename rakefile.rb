task :build_container do
    Dir.chdir('src') do
      sh "docker build -t camilin87/docker-cron ."
    end
end
