def delete_container_with_name(container_name)
    `docker rm -f #{container_name}`
    expect(`docker ps`).not_to include(container_name)
end
