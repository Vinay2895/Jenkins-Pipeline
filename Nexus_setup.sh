sudo yum update -y
sudo yum install wget -y
sudo yum install -y java-17-amazon-corretto
sudo mkdir /app && cd /app
sudo wget -O nexus.tar.gz https://download.sonatype.com/nexus/3/nexus-3.95.3-02-linux-x86_64.tar.gz
sudo tar -xvf nexus.tar.gz
#Rename the untared file to nexus.
sudo mv nexus-3* nexus
sudo adduser nexus
#Change the ownership of nexus files and nexus data directory to nexus user.
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
sudo vi  /app/nexus/bin/nexus.rc
#added .rc file
echo 'run_as_user="nexus"' | sudo tee /app/nexus/bin/nexus.rc

#Running Nexus as a System Service
sudo vi /etc/systemd/system/nexus.service

#Add the following contents to the unit file.
<<'EOF'
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

sudo chkconfig nexus on
sudo systemctl start nexus
#Default username is admin
cat /app/sonatype-work/nexus3/admin.password
