#!/bin/bash

# Update and install dependencies
apt-get update
apt-get install -y openjdk-11-jdk unzip wget

# Install PostgreSQL
apt-get install -y postgresql postgresql-contrib

# Create SonarQube database and user
sudo -u postgres psql -c "CREATE DATABASE sonarqube;"
sudo -u postgres psql -c "CREATE USER sonarqube WITH ENCRYPTED PASSWORD 'sonarqube';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonarqube;"

# Download and install SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.0.65466.zip
unzip sonarqube-9.9.0.65466.zip
mv sonarqube-9.9.0.65466 /opt/sonarqube

# Configure SonarQube
cat << EOF > /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonarqube
sonar.jdbc.password=sonarqube
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
EOF

# Create SonarQube user
useradd -r sonarqube
chown -R sonarqube:sonarqube /opt/sonarqube

# Create systemd service
cat << EOF > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonarqube
Group=sonarqube
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Start SonarQube
systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

