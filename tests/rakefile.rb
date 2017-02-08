task :default do
    puts "Running All the Integration tests"

    Rake.application.tasks
        .select { |t| t.name.start_with? "test_" }
        .each { |t|
            puts "_" * 32
            puts "- #{t}"
            puts " " * 32

            Rake::Task[t].reenable
            Rake::Task[t].invoke

            puts "_" * 32
            puts " " * 32
        }

    puts "Integration Tests Complete"
end

def assert(condition)
    raise "ERROR: Expected condition to be true but received #{condition}" unless condition
end

task :test_pull do
    sh "docker rmi alpine:latest" if `docker image ls alpine:latest`.include?("alpine")
    assert false == `docker image ls alpine:latest`.include?("alpine")

    # pulls a non-existent image
    Dir.chdir('..') do
        sh 'rake run[pull,"alpine"]'
    end
    assert true == `docker image ls alpine:latest`.include?("alpine")

    # pulls an existent image
    Dir.chdir('..') do
        sh 'rake run[pull,"alpine"]'
    end
    assert true == `docker image ls alpine:latest`.include?("alpine")
end

def delete_container_with_name(container_name)
    `docker rm -f #{container_name}`
    assert false == `docker ps`.include?(container_name)
end

task :test_run_container do
    delete_container_with_name "testnginxcontainer"

    begin
        Dir.chdir('..') do
            containerInfo = %{
                {
                    "Image": "nginx"
                }
            }

            containerInfoArg = containerInfo.gsub("\n", "").strip()

            sh "rake run[run,'#{containerInfoArg}']"
        end
        assert true == `docker ps`.include?("testnginxcontainer")
    ensure
        delete_container_with_name "testnginxcontainer"
    end
end
