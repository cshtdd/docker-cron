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
    assert `docker image ls alpine:latest`.include?("alpine") == false

    # pulls a non-existent image
    Dir.chdir('..') do
        sh 'rake run[pull,"alpine"]'
    end
    assert `docker image ls alpine:latest`.include?("alpine") == true

    # pulls an existent image
    Dir.chdir('..') do
        sh 'rake run[pull,"alpine"]'
    end
    assert `docker image ls alpine:latest`.include?("alpine") == true
end
