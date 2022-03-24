all:
    hosts:
        ${RESOURCE_NAME}:
            ansible_host: ${HOST_IP_ADDRESS}
            ansible_user: ${SSH_USER}
            ansible_ssh_private_key_file: ${PVT_KEY} 
            code_server_password: ${code_server_password}
            code_server_domain: ${code_server_domain}
