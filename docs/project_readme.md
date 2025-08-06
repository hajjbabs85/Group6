PROJECT TITLE: Personal Note-Taking Server

Project goal: to deploy a personal not-taking server on a virtual machine
Technologies used:ubuntu server,docker and docker compose and finally a joplin server

GETTING STARTED:
 Prerequistries;
   Ubuntu 20.04 (or late) vm with sudo access
   internet connection
Setup scripts;
    configures the firewall and deploys the note-taking application using docker compose
Execution;
    copy the project files including docker-compose.yaml and the scripts to your vm
    navigate the project directory : cd ~/myproject
    run the setup scripts : ./scripts/setup_notes.sh
verification:
     * docker ps : to show containers are running
     * sudo ufw status : to show the firewall is active and the needed ports are open\
Usage: 
 Accessing the server : The Joplin desktop
 URL: http://<127.0.0.1/8 scope host lo>:22300
Architecture:
 docker containers;
    *joplin-server: main app server that handles the synchronization logic for your notes
    *joplin-db:PostgreSQL database container that stores your notes securely
 networking and security: ufw blocks all incoming traffic by default,except for ssh(port 22) for remote access and the joplin server(port 22300)
Troubleshooting : 
* containers not running? docker-compose logs to see the output from the container for errors
*can't connet to the server? 
    check if the firewall is enabled and configured correctly with sudo ufw status
      confirm the vm's ip address and ensure the port is correct 
     
