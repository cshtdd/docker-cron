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

task :test_images do
    puts "test the images command"
end
