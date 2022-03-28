#!/bin/bash

sudo yum -y update

echo "Install Java JDK 8"
yum remove -y java
yum install -y java-1.8.0-openjdk

echo "Install Maven"
yum install -y maven 

echo "Install git"
yum install -y git

echo "Install Docker engine"
yum update -y
yum install docker -y
sudo usermod -a -G docker jenkins
sudo service docker start
sudo chkconfig docker on

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start  jenkins
sudo systemctl status jenkins
sudo chkconfig jenkins on
sudo usermod -a -G docker jenkins
sudo service docker start
sudo service jenkins start

echo "Install NodeJS"
sudo yum -y install curl
sudo curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs
node --version

echo "Install NG"
sudo npm install