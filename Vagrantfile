# -*- mode: ruby -*-
# vi: set ft=ruby :("2") do |config|

Vagrant.configure("2") do |config|
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "bento/centos-7.2"

  # Jenkins Configuration
  config.vm.define :jenkinsServer do |jenkins|
    jenkins.vm.network "forwarded_port", guest: 8080, host: 7080
    jenkins.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      # vb.gui = true
      vb.name = "nisum-jenkins-server"
      # Customize the amount of memory on the VM:
      vb.memory = "1024"
    end
    jenkins.vm.provision "shell", inline: <<-SHELL
      # Creating user jenkins
      useradd -m -d /home/jenkins -s /bin/bash jenkins

      # Creating group jenkins
      groupadd jenkins

      # Adding jenkins user to sudoer group
      usermod -aG wheel jenkins

      yum update -y
      yum install java-1.8.0 -y

      wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
      rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

      yum install jenkins -y
      service jenkins start
      chkconfig jenkins on
      sleep 15
      echo "******************************************"
      export initialAdminPassword=`cat /var/lib/jenkins/secrets/initialAdminPassword`
      echo "initialAdminPassword is: ${initialAdminPassword}"
      echo "******************************************"

      echo "You can find initialAdminPassword at /var/lib/jenkins/secrets/initialAdminPassword"

    SHELL
  end

  # App Server Configuration
  config.vm.define :appServer do |app|
    app.vm.network "forwarded_port", guest: 8080, host: 7081
    app.vm.provision "file", source: "./tomcat.service", destination: "/tmp/tomcat.service"
    app.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      # vb.gui = true
      vb.name = "nisum-app-server"
      # Customize the amount of memory on the VM:
      vb.memory = "1024"
    end
    app.vm.network "private_network", ip: "172.28.128.3"
    app.vm.provision "shell", inline: <<-SHELL
      # Update your CentOS system
      yum install epel-release
      yum update -y

      # Install Java
      yum install java-1.8.0-openjdk.x86_64 -y
      java -version

      # Create a dedicated user for Apache Tomcat
      groupadd tomcat
      mkdir -p /opt/tomcat
      useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

      # Get the public IP of your app Server
      # ifconfig enp0s8 | grep "inet " | awk -F' ' '{print $2}'
      echo -e "Please take a note of public IP mentioned below."
      hostname -I | awk -F' ' '{print $2}'
    SHELL
  end

  # Agent Server Configuration
  config.vm.define :agentServer do |agent|
    agent.vm.network "forwarded_port", guest: 8080, host: 7082
    app.vm.network "private_network", ip: "172.28.128.4"
    agent.vm.provider "virtualbox" do |vb|
      # Display the VirtualBox GUI when booting the machine
      # vb.gui = true
      vb.name = "nisum-agent-server"
      # Customize the amount of memory on the VM:
      vb.memory = "1024"
    end
    agent.vm.network "private_network", type: "dhcp"
    agent.vm.provision "shell", inline: <<-SHELL
      # Install Java
      yum install java-1.8.0-openjdk.x86_64 -y
      java -version

      # Get the public IP of your app Server
      echo -e "Please take a note of public IP mentioned below."
      hostname -I | awk -F' ' '{print $2}'
    SHELL
  end
end
