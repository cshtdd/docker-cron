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
