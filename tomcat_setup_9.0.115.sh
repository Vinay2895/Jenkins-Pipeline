 
#!/bin/bash

sudo yum install java -y
cd /opt
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.115/bin/apache-tomcat-9.0.115.tar.gz
sudo tar -xvf /opt/apache-tomcat-9.0.115.tar.gz

# Define the path to your manager context file
MANAGER_CONTEXT="/opt/apache-tomcat-9.0.115/webapps/manager/META-INF/context.xml"

# 1. Change RemoteCIDRValve to RemoteAddrValve
# 2. Change the allow pattern to .*
sudo sed -i 's/RemoteCIDRValve/RemoteAddrValve/g' $MANAGER_CONTEXT
sudo sed -i 's/allow="[^"]*"/allow=".*"/g' $MANAGER_CONTEXT

echo "Manager context.xml updated successfully."

cd /opt/apache-tomcat-9.0.115/conf
sudo mv tomcat-users.xml tomcat-users_bkup_9March26.xml
sudo touch tomcat-users.xml
sudo tee /opt/apache-tomcat-9.0.115/conf/tomcat-users.xml > /dev/null <<'EOF'
<?xml version="1.0" encoding="utf-8"?>
<tomcat-users>
  <role rolename="manager-gui"/>
  <role rolename="manager-html"/>
  <user username="tomcat" password="tomcat" roles="manager-gui,manager-html"/>
</tomcat-users>
EOF

cd /opt/apache-tomcat-9.0.115/conf/
sudo sed -i 's/Connector port="8080"/Connector port="8090"/g' server.xml
sudo /opt/apache-tomcat-9.0.115/bin/startup.sh