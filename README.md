# Group6
Based on the provided image, here's a step-by-step guide on how to set up a personal note-taking server on an Ubuntu virtual machine, following the project description.

Prerequisites
An Ubuntu virtual machine (VM) with network connectivity.

Basic knowledge of the Linux command line.

sudo privileges on the VM.

Step 1: Prepare the Ubuntu VM
First, ensure your VM is up to date and has the necessary tools installed.

Update system packages:

Bash

sudo apt update
sudo apt upgrade -y
Install essential tools: You'll need curl or wget to download files and git if you plan to use a GitHub repository.

Bash

sudo apt install -y curl git
Step 2: Install Docker and Docker Compose
Docker is required to run the containerized note-taking app.

Install Docker: The easiest way is to use the official convenience script.

Bash

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
Add your user to the docker group: This allows you to run docker commands without sudo.

Bash

sudo usermod -aG docker $USER
Note: You must log out and log back in (or restart your terminal) for this change to take effect.

Install Docker Compose: This is useful for managing multi-container applications.

Bash

sudo apt install -y docker-compose
Verify installations:

Bash

docker --version
docker-compose --version
Step 3: Choose a Note-Taking App and Set Up the Project Directory
The project mentions Joplin as an example. We'll use its server component.

Create a project directory:

Bash

mkdir -p ~/myproject/scripts
cd ~/myproject
Create a Docker Compose file: This file will define the services (Joplin server and a database).

Bash

nano docker-compose.yml
Paste the following content into docker-compose.yml: (This is a common setup for Joplin Server)

YAML

version: '3'

services:
  joplin-db:
    image: postgres:13
    restart: always
    volumes:
      - ./joplin_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: joplin
      POSTGRES_PASSWORD: your_strong_database_password
      POSTGRES_DB: joplin
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U joplin"]
      interval: 10s
      timeout: 5s
      retries: 5

  joplin-server:
    image: joplin/server:latest
    restart: always
    ports:
      - "22300:22300"
    depends_on:
      joplin-db:
        condition: service_healthy
    environment:
      APP_BASE_URL: http://your_vm_ip_or_domain:22300
      DB_CLIENT: pg
      POSTGRES_HOST: joplin-db
      POSTGRES_PORT: 5432
      POSTGRES_DATABASE: joplin
      POSTGRES_USER: joplin
      POSTGRES_PASSWORD: your_strong_database_password
Important:

Replace your_strong_database_password with a secure password.

Replace your_vm_ip_or_domain with the IP address of your Ubuntu VM.

Step 4: Write the Setup Script (setup_notes.sh)
This script will automate the entire setup process for reproducibility.

Create the script file:

Bash

nano ~/myproject/scripts/setup_notes.sh
Add the script content:

Bash

#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Step 1: Update and Install Dependencies ---
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl git docker.io docker-compose ufw

# --- Step 2: Add current user to the docker group ---
echo "Adding current user to the docker group..."
sudo usermod -aG docker $USER
# Note: Log out and log back in for this to take effect

# --- Step 3: Create and configure project directory and files ---
echo "Creating project directory and files..."
mkdir -p ~/myproject/joplin_data
cd ~/myproject

# Create a Docker Compose file (if it doesn't exist)
# This part should be handled manually or templated, but for the script,
# we'll assume it exists or create a basic one.
cat <<EOF > docker-compose.yml
version: '3'
services:
  joplin-db:
    image: postgres:13
    restart: always
    volumes:
      - ./joplin_data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: joplin
      POSTGRES_PASSWORD: your_strong_database_password
      POSTGRES_DB: joplin
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U joplin"]
      interval: 10s
      timeout: 5s
      retries: 5

  joplin-server:
    image: joplin/server:latest
    restart: always
    ports:
      - "22300:22300"
    depends_on:
      joplin-db:
        condition: service_healthy
    environment:
      APP_BASE_URL: http://your_vm_ip_or_domain:22300
      DB_CLIENT: pg
      POSTGRES_HOST: joplin-db
      POSTGRES_PORT: 5432
      POSTGRES_DATABASE: joplin
      POSTGRES_USER: joplin
      POSTGRES_PASSWORD: your_strong_database_password
EOF

# --- Step 4: Configure the firewall (UFW) ---
echo "Configuring Uncomplicated Firewall (UFW)..."
# Deny all incoming by default
sudo ufw default deny incoming
# Allow outgoing by default
sudo ufw default allow outgoing
# Allow SSH for remote access (port 22)
sudo ufw allow ssh
# Allow the Joplin Server port (22300)
sudo ufw allow 22300/tcp
# Enable UFW
sudo ufw --force enable
sudo ufw status

# --- Step 5: Deploy the containers ---
echo "Deploying the Joplin containers with Docker Compose..."
docker-compose up -d

echo "Setup complete. The Joplin server is now running."
echo "You may need to log out and log back in for the 'docker' group changes to take effect."
echo "To check the container status, run: docker ps"
echo "To check the UFW status, run: sudo ufw status"
Make the script executable:

Bash

chmod +x ~/myproject/scripts/setup_notes.sh
Step 5: Configure UFW and Deploy
The script already includes these steps, but here's the manual breakdown if you prefer.

Configure UFW (Uncomplicated Firewall):

Bash

# Deny all incoming traffic by default
sudo ufw default deny incoming
# Allow all outgoing traffic by default
sudo ufw default allow outgoing
# Allow incoming SSH connections
sudo ufw allow ssh
# Allow incoming connections on the Joplin port (22300)
sudo ufw allow 22300/tcp
# Enable the firewall
sudo ufw enable
# Verify the status
sudo ufw status
Deploy the application:

Bash

cd ~/myproject
docker-compose up -d
Step 6: Create Documentation and Gather Deliverables
Create the documentation file:

Bash

mkdir -p ~/myproject/docs
nano ~/myproject/docs/project_readme.md
Write the documentation: Explain what the project is, how to use the setup_notes.sh script, how to access the server, and what each component does.

Gather screenshots:

docker ps: This command shows running containers.

web app: Take a screenshot of the Joplin server's web interface by navigating to http://<your_vm_ip>:22300 in your web browser.

sudo ufw status: This command shows the firewall rules.

(Optional) GitHub Repo:

Initialize a git repository in your ~/myproject directory.

Add your script, documentation, and docker-compose.yml file.

Create a .gitignore file to exclude the joplin_data directory.

Push the code to a new GitHub repository.

This comprehensive guide covers all the steps and deliverables mentioned in the project description, from scripting to security and deployment on an Ubuntu VM.


