set -e
sudo apt update
sudo apt upgrade -y
sudo apt install docker -y curl git docker.io docker-compose ufw
sudo usermod -aG docker $USER
echo  "creating directory files..."
mkdir -p ~/myproject/joplin_data
cd ~/myproject
cat <<EOF > docker-compose.yaml
version:'3'
services: 
 joplin-db:
  image: postgres: 13
  restart: always
  volumes:
    -./jplin_data:/var/lib/postgresql/data
  environment:
   POSTGRES_USER: joplin
   POSTGRES_PASSWORD: Btctgrp6.eve
   POSTGRES_DB: joplin
  healthcheck:
    test:["CMD-SHELL", "pg_isready -U joplin"]
    interval: 10s
    timeout: 5s
    retries: 5
  joplin-server:
    image:joplin/server:latest
    restart: always
    ports:
     -"22300:22300"
    depends_on:
    joplin-db:
     conditions: service_healthy
    environment:
     APP_BASE_URL: http://120.0.0.1/8:22300
    DB_CLIENT:pg
    POSTGRES_HOST: jopLIN-db
    POSTGRES_PORT: 5432
    POSTGRES_DATABASE: joplin
    POSTGRES_USER: joplin
    POSTGRES_PASSWORD: Btctgrp6.eve

echo"configuring ufw"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22300/tcp
sudo ufw --force enable
sudo ufw status

echo"deploying the japlin containers with docker compose..."
docker-compose up -d

echo "setup complete. the joplin is now running."
echo "you may need to log out and log back in for the 'docker' group changes to take effect"
echo "to check the container status, run: docker ps"
echo "to check the ufw status, run: sudo ufw status"
