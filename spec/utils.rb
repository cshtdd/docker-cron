def delete_container_with_name(container_name)
    `docker rm -f #{container_name}`
    expect(`docker ps`).not_to include(container_name)
end

def build_container_info_arg(containerInfoJson)
    containerInfoJson.gsub("\n", "").strip()
end

def sh(command)
    puts "sh #{command}"
    result = system(command)
    result
end
